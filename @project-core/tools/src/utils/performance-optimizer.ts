/**
 * Performance Optimizer for NEON PRO V2.0
 * Automatically detects device capabilities and optimizes visual effects
 */

interface PerformanceMetrics {
  fps: number;
  deviceMemory: number;
  hardwareConcurrency: number;
  connectionType: string;
  isLowEndDevice: boolean;
}

class PerformanceOptimizer {
  private metrics: PerformanceMetrics;
  private performanceMode: 'high' | 'medium' | 'low' = 'high';
  private frameCount = 0;
  private lastTime = performance.now();
  private fpsHistory: number[] = [];

  constructor() {
    this.metrics = this.detectDeviceCapabilities();
    this.determinePerformanceMode();
    this.applyOptimizations();
    this.startFPSMonitoring();
  }

  private detectDeviceCapabilities(): PerformanceMetrics {
    const nav = navigator as any;
    
    return {
      fps: 60, // Will be updated by monitoring
      deviceMemory: nav.deviceMemory || 4, // GB
      hardwareConcurrency: nav.hardwareConcurrency || 4,
      connectionType: nav.connection?.effectiveType || '4g',
      isLowEndDevice: this.isLowEndDevice()
    };
  }

  private isLowEndDevice(): boolean {
    const nav = navigator as any;
    
    // Check for low-end indicators
    const lowMemory = (nav.deviceMemory || 4) < 4;
    const lowCores = (nav.hardwareConcurrency || 4) < 4;
    const slowConnection = ['slow-2g', '2g', '3g'].includes(nav.connection?.effectiveType);
    const isMobile = /Android|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
    
    return lowMemory || lowCores || slowConnection || (isMobile && lowMemory);
  }

  private determinePerformanceMode(): void {
    if (this.metrics.isLowEndDevice) {
      this.performanceMode = 'low';
    } else if (this.metrics.deviceMemory < 8 || this.metrics.hardwareConcurrency < 8) {
      this.performanceMode = 'medium';
    } else {
      this.performanceMode = 'high';
    }

    console.log(`🎯 Performance Mode: ${this.performanceMode}`, this.metrics);
  }

  private applyOptimizations(): void {
    const body = document.body;
    
    // Remove existing performance classes
    body.classList.remove('performance-high', 'performance-medium', 'performance-low');
    
    // Apply performance mode class
    body.classList.add(`performance-${this.performanceMode}`);

    // Apply specific optimizations based on mode
    switch (this.performanceMode) {
      case 'low':
        this.applyLowPerformanceMode();
        break;
      case 'medium':
        this.applyMediumPerformanceMode();
        break;
      case 'high':
        this.applyHighPerformanceMode();
        break;
    }
  }

  private applyLowPerformanceMode(): void {
    // Disable heavy animations
    const style = document.createElement('style');
    style.textContent = `
      .performance-low .animate-glow,
      .performance-low .animate-pulse-neon,
      .performance-low .animate-float {
        animation: none !important;
      }
      
      .performance-low .card-hover:hover {
        transform: none !important;
        box-shadow: none !important;
      }
      
      .performance-low .animate-gradient-shift {
        animation: none !important;
        background: linear-gradient(135deg, hsl(var(--primary)) 0%, hsl(var(--accent)) 100%) !important;
      }
    `;
    document.head.appendChild(style);
  }

  private applyMediumPerformanceMode(): void {
    // Reduce animation intensity
    const style = document.createElement('style');
    style.textContent = `
      .performance-medium .animate-glow {
        animation-duration: 4s !important;
      }
      
      .performance-medium .animate-pulse-neon {
        animation-duration: 3s !important;
      }
      
      .performance-medium .card-hover:hover {
        transform: translate3d(0, -1px, 0) !important;
      }
    `;
    document.head.appendChild(style);
  }

  private applyHighPerformanceMode(): void {
    // Enable all effects with GPU acceleration
    const style = document.createElement('style');
    style.textContent = `
      .performance-high .animate-glow,
      .performance-high .animate-pulse-neon,
      .performance-high .card-hover {
        will-change: transform, filter, box-shadow;
        transform: translateZ(0);
      }
    `;
    document.head.appendChild(style);
  }

  private startFPSMonitoring(): void {
    const measureFPS = () => {
      this.frameCount++;
      const currentTime = performance.now();
      
      if (currentTime >= this.lastTime + 1000) {
        const fps = Math.round((this.frameCount * 1000) / (currentTime - this.lastTime));
        this.fpsHistory.push(fps);
        
        // Keep only last 10 measurements
        if (this.fpsHistory.length > 10) {
          this.fpsHistory.shift();
        }
        
        // Calculate average FPS
        const avgFPS = this.fpsHistory.reduce((a, b) => a + b, 0) / this.fpsHistory.length;
        this.metrics.fps = avgFPS;
        
        // Auto-adjust performance mode if FPS drops
        this.autoAdjustPerformance(avgFPS);
        
        this.frameCount = 0;
        this.lastTime = currentTime;
      }
      
      requestAnimationFrame(measureFPS);
    };
    
    requestAnimationFrame(measureFPS);
  }

  private autoAdjustPerformance(avgFPS: number): void {
    if (avgFPS < 30 && this.performanceMode !== 'low') {
      console.warn('🐌 Low FPS detected, switching to low performance mode');
      this.performanceMode = 'low';
      this.applyOptimizations();
    } else if (avgFPS < 45 && this.performanceMode === 'high') {
      console.warn('⚡ Medium FPS detected, switching to medium performance mode');
      this.performanceMode = 'medium';
      this.applyOptimizations();
    }
  }

  // Public methods
  public getMetrics(): PerformanceMetrics & { performanceMode: string } {
    return {
      ...this.metrics,
      performanceMode: this.performanceMode
    };
  }

  public forcePerformanceMode(mode: 'high' | 'medium' | 'low'): void {
    this.performanceMode = mode;
    this.applyOptimizations();
    console.log(`🔧 Performance mode manually set to: ${mode}`);
  }

  public enablePerformanceMonitoring(): void {
    // Add performance indicator to page
    const indicator = document.createElement('div');
    indicator.id = 'performance-indicator';
    indicator.style.cssText = `
      position: fixed;
      top: 10px;
      right: 10px;
      background: rgba(0, 0, 0, 0.8);
      color: white;
      padding: 8px 12px;
      border-radius: 8px;
      font-family: monospace;
      font-size: 12px;
      z-index: 9999;
      pointer-events: none;
    `;
    
    document.body.appendChild(indicator);
    
    setInterval(() => {
      const color = this.metrics.fps > 50 ? '#00ff00' : 
                   this.metrics.fps > 30 ? '#ffff00' : '#ff0000';
      
      indicator.innerHTML = `
        FPS: <span style="color: ${color}">${Math.round(this.metrics.fps)}</span><br>
        Mode: ${this.performanceMode}
      `;
    }, 1000);
  }
}

// Initialize performance optimizer
let performanceOptimizer: PerformanceOptimizer;

export const initializePerformanceOptimizer = () => {
  if (typeof window !== 'undefined' && !performanceOptimizer) {
    performanceOptimizer = new PerformanceOptimizer();
    
    // Enable monitoring in development
    if (process.env.NODE_ENV === 'development') {
      performanceOptimizer.enablePerformanceMonitoring();
    }
  }
  return performanceOptimizer;
};

export const getPerformanceOptimizer = () => performanceOptimizer;

export default PerformanceOptimizer;
