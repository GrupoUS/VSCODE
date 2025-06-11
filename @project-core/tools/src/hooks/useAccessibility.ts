"use client";

import { useEffect, useState } from 'react';

interface AccessibilityPreferences {
  prefersReducedMotion: boolean;
  prefersHighContrast: boolean;
  prefersColorScheme: 'light' | 'dark' | 'no-preference';
  isKeyboardUser: boolean;
}

export function useAccessibility() {
  const [preferences, setPreferences] = useState<AccessibilityPreferences>({
    prefersReducedMotion: false,
    prefersHighContrast: false,
    prefersColorScheme: 'no-preference',
    isKeyboardUser: false,
  });

  useEffect(() => {
    if (typeof window === 'undefined') return;

    // Check for reduced motion preference
    const reducedMotionQuery = window.matchMedia('(prefers-reduced-motion: reduce)');
    
    // Check for high contrast preference
    const highContrastQuery = window.matchMedia('(prefers-contrast: high)');
    
    // Check for color scheme preference
    const darkSchemeQuery = window.matchMedia('(prefers-color-scheme: dark)');
    const lightSchemeQuery = window.matchMedia('(prefers-color-scheme: light)');

    // Update preferences
    const updatePreferences = () => {
      setPreferences({
        prefersReducedMotion: reducedMotionQuery.matches,
        prefersHighContrast: highContrastQuery.matches,
        prefersColorScheme: darkSchemeQuery.matches ? 'dark' : 
                           lightSchemeQuery.matches ? 'light' : 'no-preference',
        isKeyboardUser: document.body.classList.contains('keyboard-user'),
      });
    };

    // Initial check
    updatePreferences();

    // Listen for changes
    reducedMotionQuery.addEventListener('change', updatePreferences);
    highContrastQuery.addEventListener('change', updatePreferences);
    darkSchemeQuery.addEventListener('change', updatePreferences);
    lightSchemeQuery.addEventListener('change', updatePreferences);

    // Keyboard navigation detection
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Tab') {
        document.body.classList.add('keyboard-user');
        updatePreferences();
      }
    };

    const handleMouseDown = () => {
      document.body.classList.remove('keyboard-user');
      updatePreferences();
    };

    document.addEventListener('keydown', handleKeyDown);
    document.addEventListener('mousedown', handleMouseDown);

    // Apply accessibility classes to body
    const applyAccessibilityClasses = () => {
      const body = document.body;
      
      // Reduced motion
      if (preferences.prefersReducedMotion) {
        body.classList.add('reduce-motion');
      } else {
        body.classList.remove('reduce-motion');
      }
      
      // High contrast
      if (preferences.prefersHighContrast) {
        body.classList.add('high-contrast');
      } else {
        body.classList.remove('high-contrast');
      }
    };

    applyAccessibilityClasses();

    // Cleanup
    return () => {
      reducedMotionQuery.removeEventListener('change', updatePreferences);
      highContrastQuery.removeEventListener('change', updatePreferences);
      darkSchemeQuery.removeEventListener('change', updatePreferences);
      lightSchemeQuery.removeEventListener('change', updatePreferences);
      document.removeEventListener('keydown', handleKeyDown);
      document.removeEventListener('mousedown', handleMouseDown);
    };
  }, [preferences.prefersReducedMotion, preferences.prefersHighContrast]);

  // Helper functions
  const announceToScreenReader = (message: string) => {
    const announcement = document.createElement('div');
    announcement.setAttribute('aria-live', 'polite');
    announcement.setAttribute('aria-atomic', 'true');
    announcement.style.position = 'absolute';
    announcement.style.left = '-10000px';
    announcement.style.width = '1px';
    announcement.style.height = '1px';
    announcement.style.overflow = 'hidden';
    announcement.textContent = message;
    
    document.body.appendChild(announcement);
    
    setTimeout(() => {
      document.body.removeChild(announcement);
    }, 1000);
  };

  const focusElement = (selector: string) => {
    const element = document.querySelector(selector) as HTMLElement;
    if (element) {
      element.focus();
      element.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  };

  const skipToContent = () => {
    focusElement('#main-content, main, [role="main"]');
  };

  const getAccessibilityClasses = () => {
    const classes = [];
    
    if (preferences.prefersReducedMotion) {
      classes.push('reduce-motion');
    }
    
    if (preferences.prefersHighContrast) {
      classes.push('high-contrast');
    }
    
    if (preferences.isKeyboardUser) {
      classes.push('keyboard-user');
    }
    
    return classes.join(' ');
  };

  return {
    preferences,
    announceToScreenReader,
    focusElement,
    skipToContent,
    getAccessibilityClasses,
    // Utility functions
    isReducedMotion: preferences.prefersReducedMotion,
    isHighContrast: preferences.prefersHighContrast,
    isKeyboardUser: preferences.isKeyboardUser,
    isDarkMode: preferences.prefersColorScheme === 'dark',
  };
}

export default useAccessibility;
