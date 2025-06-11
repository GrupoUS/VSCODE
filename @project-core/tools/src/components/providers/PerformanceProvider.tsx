"use client";

import { useEffect, createContext, useContext, ReactNode } from 'react';
import { initializePerformanceOptimizer, getPerformanceOptimizer } from '@/utils/performance-optimizer';

interface PerformanceContextType {
  optimizer: any;
  forceMode: (mode: 'high' | 'medium' | 'low') => void;
  getMetrics: () => any;
}

const PerformanceContext = createContext<PerformanceContextType | null>(null);

interface PerformanceProviderProps {
  children: ReactNode;
}

export function PerformanceProvider({ children }: PerformanceProviderProps) {
  useEffect(() => {
    // Initialize performance optimizer on client side
    const optimizer = initializePerformanceOptimizer();
    
    // Add reduced motion detection
    const mediaQuery = window.matchMedia('(prefers-reduced-motion: reduce)');
    
    const handleReducedMotion = (e: MediaQueryListEvent) => {
      if (e.matches) {
        // User prefers reduced motion
        optimizer?.forcePerformanceMode('low');
        console.log('🎯 Reduced motion detected, switching to low performance mode');
      }
    };
    
    // Listen for changes in motion preference
    mediaQuery.addEventListener('change', handleReducedMotion);
    
    // Check initial state
    if (mediaQuery.matches) {
      optimizer?.forcePerformanceMode('low');
    }
    
    // Add performance CSS variables to document
    const root = document.documentElement;
    root.style.setProperty('--performance-mode', optimizer?.getMetrics().performanceMode || 'high');
    
    // Cleanup
    return () => {
      mediaQuery.removeEventListener('change', handleReducedMotion);
    };
  }, []);

  const contextValue: PerformanceContextType = {
    optimizer: getPerformanceOptimizer(),
    forceMode: (mode: 'high' | 'medium' | 'low') => {
      const optimizer = getPerformanceOptimizer();
      if (optimizer) {
        optimizer.forcePerformanceMode(mode);
        document.documentElement.style.setProperty('--performance-mode', mode);
      }
    },
    getMetrics: () => {
      const optimizer = getPerformanceOptimizer();
      return optimizer ? optimizer.getMetrics() : null;
    }
  };

  return (
    <PerformanceContext.Provider value={contextValue}>
      {children}
    </PerformanceContext.Provider>
  );
}

export function usePerformance() {
  const context = useContext(PerformanceContext);
  if (!context) {
    throw new Error('usePerformance must be used within a PerformanceProvider');
  }
  return context;
}

export default PerformanceProvider;
