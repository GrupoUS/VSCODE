"use client";

import { useEffect, useState } from 'react';

interface DeviceInfo {
  isMobile: boolean;
  isTablet: boolean;
  isDesktop: boolean;
  isTouchDevice: boolean;
  isLowEndDevice: boolean;
  screenSize: 'sm' | 'md' | 'lg' | 'xl' | '2xl';
  orientation: 'portrait' | 'landscape';
  connectionType: string;
  deviceMemory: number;
  hardwareConcurrency: number;
}

export function useDevice() {
  const [deviceInfo, setDeviceInfo] = useState<DeviceInfo>({
    isMobile: false,
    isTablet: false,
    isDesktop: true,
    isTouchDevice: false,
    isLowEndDevice: false,
    screenSize: 'lg',
    orientation: 'landscape',
    connectionType: '4g',
    deviceMemory: 4,
    hardwareConcurrency: 4,
  });

  useEffect(() => {
    if (typeof window === 'undefined') return;

    const updateDeviceInfo = () => {
      const width = window.innerWidth;
      const height = window.innerHeight;
      const nav = navigator as any;

      // Screen size detection
      let screenSize: DeviceInfo['screenSize'] = 'lg';
      if (width < 640) screenSize = 'sm';
      else if (width < 768) screenSize = 'md';
      else if (width < 1024) screenSize = 'lg';
      else if (width < 1280) screenSize = 'xl';
      else screenSize = '2xl';

      // Device type detection
      const isMobile = width < 768;
      const isTablet = width >= 768 && width < 1024;
      const isDesktop = width >= 1024;

      // Touch device detection
      const isTouchDevice = 'ontouchstart' in window || 
                           navigator.maxTouchPoints > 0 ||
                           (navigator as any).msMaxTouchPoints > 0;

      // Low-end device detection
      const deviceMemory = nav.deviceMemory || 4;
      const hardwareConcurrency = nav.hardwareConcurrency || 4;
      const connectionType = nav.connection?.effectiveType || '4g';
      
      const isLowEndDevice = 
        deviceMemory < 4 || 
        hardwareConcurrency < 4 || 
        ['slow-2g', '2g', '3g'].includes(connectionType) ||
        (isMobile && deviceMemory < 4);

      // Orientation detection
      const orientation = height > width ? 'portrait' : 'landscape';

      setDeviceInfo({
        isMobile,
        isTablet,
        isDesktop,
        isTouchDevice,
        isLowEndDevice,
        screenSize,
        orientation,
        connectionType,
        deviceMemory,
        hardwareConcurrency,
      });

      // Apply device classes to body
      const body = document.body;
      body.classList.remove('mobile', 'tablet', 'desktop', 'touch', 'low-end', 'portrait', 'landscape');
      
      if (isMobile) body.classList.add('mobile');
      if (isTablet) body.classList.add('tablet');
      if (isDesktop) body.classList.add('desktop');
      if (isTouchDevice) body.classList.add('touch');
      if (isLowEndDevice) body.classList.add('low-end');
      body.classList.add(orientation);
    };

    // Initial detection
    updateDeviceInfo();

    // Listen for resize and orientation changes
    window.addEventListener('resize', updateDeviceInfo);
    window.addEventListener('orientationchange', updateDeviceInfo);

    // Listen for connection changes
    if ('connection' in navigator) {
      (navigator as any).connection.addEventListener('change', updateDeviceInfo);
    }

    return () => {
      window.removeEventListener('resize', updateDeviceInfo);
      window.removeEventListener('orientationchange', updateDeviceInfo);
      if ('connection' in navigator) {
        (navigator as any).connection.removeEventListener('change', updateDeviceInfo);
      }
    };
  }, []);

  // Helper functions
  const getOptimizedImageSize = () => {
    if (deviceInfo.isMobile) return { width: 400, height: 300 };
    if (deviceInfo.isTablet) return { width: 800, height: 600 };
    return { width: 1200, height: 900 };
  };

  const shouldReduceAnimations = () => {
    return deviceInfo.isLowEndDevice || deviceInfo.isMobile;
  };

  const getPerformanceMode = (): 'high' | 'medium' | 'low' => {
    if (deviceInfo.isLowEndDevice) return 'low';
    if (deviceInfo.isMobile || deviceInfo.isTablet) return 'medium';
    return 'high';
  };

  const getDeviceClasses = () => {
    const classes = [];
    
    if (deviceInfo.isMobile) classes.push('mobile');
    if (deviceInfo.isTablet) classes.push('tablet');
    if (deviceInfo.isDesktop) classes.push('desktop');
    if (deviceInfo.isTouchDevice) classes.push('touch');
    if (deviceInfo.isLowEndDevice) classes.push('low-end');
    classes.push(deviceInfo.orientation);
    classes.push(deviceInfo.screenSize);
    
    return classes.join(' ');
  };

  const isBreakpoint = (breakpoint: 'sm' | 'md' | 'lg' | 'xl' | '2xl') => {
    const breakpoints = {
      sm: 640,
      md: 768,
      lg: 1024,
      xl: 1280,
      '2xl': 1536,
    };
    
    return window.innerWidth >= breakpoints[breakpoint];
  };

  return {
    ...deviceInfo,
    getOptimizedImageSize,
    shouldReduceAnimations,
    getPerformanceMode,
    getDeviceClasses,
    isBreakpoint,
    // Utility getters
    isSmallScreen: deviceInfo.screenSize === 'sm',
    isMediumScreen: deviceInfo.screenSize === 'md',
    isLargeScreen: deviceInfo.screenSize === 'lg',
    isExtraLargeScreen: deviceInfo.screenSize === 'xl' || deviceInfo.screenSize === '2xl',
  };
}

export default useDevice;
