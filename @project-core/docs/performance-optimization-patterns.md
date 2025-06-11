# 📊 PERFORMANCE OPTIMIZATION PATTERNS

**Version**: 2.0  
**Status**: Active  
**Last Updated**: 2025-06-07  
**Based on**: NEONPRO, AegisWallet, Harmoniza-Facil-Agendas optimizations  

## 📋 OVERVIEW

Padrões de otimização de performance consolidados dos 3 projetos GRUPO US, incluindo métricas, técnicas e estratégias validadas para máxima eficiência.

## 🎯 PERFORMANCE TARGETS

### **Core Web Vitals**
```yaml
Largest Contentful Paint (LCP): < 2.5s
First Input Delay (FID): < 100ms
Cumulative Layout Shift (CLS): < 0.1
First Contentful Paint (FCP): < 1.8s
Time to Interactive (TTI): < 3.8s
Total Blocking Time (TBT): < 200ms
```

### **Bundle Size Targets**
```yaml
Initial Bundle: < 100KB (gzipped)
Total JavaScript: < 150KB (gzipped)
CSS Bundle: < 50KB (gzipped)
Images: WebP/AVIF optimized
Fonts: < 100KB total
```

### **Runtime Performance**
```yaml
Memory Usage: < 50MB baseline
CPU Usage: < 30% average
Frame Rate: 60fps consistent
Network Requests: < 20 initial
Cache Hit Rate: > 90%
```

## 🚀 BUNDLE OPTIMIZATION

### **Code Splitting Strategies**
```typescript
// Route-based splitting (Next.js)
const DashboardPage = dynamic(() => import('@/pages/Dashboard'), {
  loading: () => <PageSkeleton />,
  ssr: false,
});

// Component-based splitting
const HeavyChart = lazy(() => import('@/components/HeavyChart'));

// Feature-based splitting
const AdminPanel = lazy(() => 
  import('@/features/admin').then(module => ({ default: module.AdminPanel }))
);

// Conditional loading
const DevTools = lazy(() => 
  process.env.NODE_ENV === 'development' 
    ? import('@/components/DevTools')
    : Promise.resolve({ default: () => null })
);
```

### **Tree Shaking Optimization**
```typescript
// Correct: Named imports
import { Button, Card } from '@/components/ui';
import { format } from 'date-fns';

// Incorrect: Default imports from large libraries
import * as _ from 'lodash'; // ❌
import moment from 'moment'; // ❌

// Optimized alternatives
import { debounce } from 'lodash-es'; // ✅
import { format } from 'date-fns'; // ✅
```

### **Webpack/Vite Bundle Analysis**
```typescript
// Next.js bundle analysis
const withBundleAnalyzer = require('@next/bundle-analyzer')({
  enabled: process.env.ANALYZE === 'true',
});

module.exports = withBundleAnalyzer({
  experimental: {
    optimizeCss: true,
  },
});

// Vite bundle analysis
import { defineConfig } from 'vite';
import { analyzer } from 'vite-bundle-analyzer';

export default defineConfig({
  plugins: [
    analyzer({
      analyzerMode: 'server',
      openAnalyzer: true,
    }),
  ],
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          ui: ['@radix-ui/react-slot', 'lucide-react'],
          utils: ['clsx', 'tailwind-merge'],
        },
      },
    },
  },
});
```

## 🖼️ IMAGE OPTIMIZATION

### **Next.js Image Optimization**
```typescript
import Image from 'next/image';

// Optimized image component
export function OptimizedImage({ src, alt, ...props }) {
  return (
    <Image
      src={src}
      alt={alt}
      placeholder="blur"
      blurDataURL="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQ..."
      sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
      quality={85}
      priority={false}
      {...props}
    />
  );
}

// Configuration
// next.config.ts
const nextConfig = {
  images: {
    formats: ['image/webp', 'image/avif'],
    deviceSizes: [640, 750, 828, 1080, 1200, 1920, 2048, 3840],
    imageSizes: [16, 32, 48, 64, 96, 128, 256, 384],
    domains: ['example.com'],
  },
};
```

### **Vite Image Optimization**
```typescript
// Vite image imports
import heroImage from '@/assets/hero.jpg?w=800&h=600&format=webp';
import thumbnailImage from '@/assets/thumbnail.jpg?w=200&h=200&format=avif';

// Dynamic image loading
const ImageComponent = ({ src, alt }) => {
  const [imageSrc, setImageSrc] = useState(null);
  
  useEffect(() => {
    const img = new Image();
    img.onload = () => setImageSrc(src);
    img.src = src;
  }, [src]);

  return imageSrc ? <img src={imageSrc} alt={alt} /> : <ImageSkeleton />;
};
```

## 🎨 CSS OPTIMIZATION

### **Critical CSS Extraction**
```css
/* Critical CSS (above-the-fold) */
.hero-section {
  background: var(--background);
  color: var(--text-primary);
  min-height: 100vh;
}

.btn-primary {
  background: var(--accent-gold);
  color: var(--primary-dark);
  padding: 1rem 2rem;
}

/* Non-critical CSS (lazy loaded) */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
}
```

### **CSS-in-JS Optimization**
```typescript
// Styled-components optimization
const StyledButton = styled.button.attrs(props => ({
  type: props.type || 'button',
}))`
  background: var(--accent-gold);
  color: var(--primary-dark);
  transition: all 0.3s ease;
  
  &:hover {
    transform: translateY(-1px);
    box-shadow: 0 0 20px rgba(172, 148, 105, 0.5);
  }
`;

// Emotion optimization
const buttonStyles = css`
  background: var(--accent-gold);
  color: var(--primary-dark);
`;
```

## 🔄 CACHING STRATEGIES

### **Browser Caching**
```typescript
// Service Worker caching
const CACHE_NAME = 'grupo-us-v1';
const urlsToCache = [
  '/',
  '/static/css/main.css',
  '/static/js/main.js',
  '/assets/fonts/inter.woff2',
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
  );
});

// HTTP caching headers
// next.config.ts
const nextConfig = {
  async headers() {
    return [
      {
        source: '/assets/:path*',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=31536000, immutable',
          },
        ],
      },
    ];
  },
};
```

### **Memory Caching**
```typescript
// React Query caching
import { useQuery } from '@tanstack/react-query';

const useUserData = (userId: string) => {
  return useQuery({
    queryKey: ['user', userId],
    queryFn: () => fetchUser(userId),
    staleTime: 5 * 60 * 1000, // 5 minutes
    cacheTime: 10 * 60 * 1000, // 10 minutes
  });
};

// SWR caching
import useSWR from 'swr';

const useUserData = (userId: string) => {
  return useSWR(`/api/users/${userId}`, fetcher, {
    revalidateOnFocus: false,
    revalidateOnReconnect: false,
    dedupingInterval: 60000,
  });
};
```

## ⚡ RUNTIME OPTIMIZATION

### **React Performance Patterns**
```typescript
// Memoization
const ExpensiveComponent = memo(({ data, onUpdate }) => {
  const processedData = useMemo(() => {
    return data.map(item => ({
      ...item,
      processed: expensiveCalculation(item),
    }));
  }, [data]);

  const handleUpdate = useCallback((id: string) => {
    onUpdate(id);
  }, [onUpdate]);

  return (
    <div>
      {processedData.map(item => (
        <Item key={item.id} data={item} onUpdate={handleUpdate} />
      ))}
    </div>
  );
});

// Virtual scrolling for large lists
import { FixedSizeList as List } from 'react-window';

const VirtualizedList = ({ items }) => (
  <List
    height={600}
    itemCount={items.length}
    itemSize={50}
    itemData={items}
  >
    {({ index, style, data }) => (
      <div style={style}>
        <Item data={data[index]} />
      </div>
    )}
  </List>
);
```

### **State Management Optimization**
```typescript
// Zustand optimization
const useStore = create((set, get) => ({
  users: [],
  selectedUser: null,
  
  // Optimized selectors
  getUser: (id: string) => get().users.find(user => user.id === id),
  
  // Batch updates
  updateUsers: (updates: UserUpdate[]) => set(state => ({
    users: state.users.map(user => {
      const update = updates.find(u => u.id === user.id);
      return update ? { ...user, ...update } : user;
    }),
  })),
}));

// Selective subscriptions
const UserProfile = () => {
  const selectedUser = useStore(state => state.selectedUser);
  // Only re-renders when selectedUser changes
};
```

## 📊 MONITORING & METRICS

### **Performance Monitoring**
```typescript
// Web Vitals tracking
import { getCLS, getFID, getFCP, getLCP, getTTFB } from 'web-vitals';

function sendToAnalytics(metric) {
  // Send to your analytics service
  analytics.track('Web Vital', {
    name: metric.name,
    value: metric.value,
    id: metric.id,
  });
}

getCLS(sendToAnalytics);
getFID(sendToAnalytics);
getFCP(sendToAnalytics);
getLCP(sendToAnalytics);
getTTFB(sendToAnalytics);

// Custom performance marks
performance.mark('component-render-start');
// ... component rendering
performance.mark('component-render-end');
performance.measure('component-render', 'component-render-start', 'component-render-end');
```

### **Bundle Size Monitoring**
```typescript
// Bundle size tracking
const bundleSizeConfig = {
  maxSize: {
    'dist/index.js': '100kb',
    'dist/vendor.js': '150kb',
    'dist/style.css': '50kb',
  },
  compression: 'gzip',
};

// Performance budget
const performanceBudget = {
  'first-contentful-paint': 1800,
  'largest-contentful-paint': 2500,
  'cumulative-layout-shift': 0.1,
  'total-blocking-time': 200,
};
```

## 🧪 PERFORMANCE TESTING

### **Lighthouse CI**
```yaml
# .github/workflows/lighthouse.yml
name: Lighthouse CI
on: [push]
jobs:
  lighthouse:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Lighthouse CI
        run: |
          npm install -g @lhci/cli@0.12.x
          lhci autorun
```

### **Performance Testing Scripts**
```bash
#!/bin/bash
# performance-test.sh

echo "🚀 Running Performance Tests..."

# Build optimization
npm run build

# Bundle analysis
npm run analyze

# Lighthouse audit
lighthouse --output=json --output-path=./lighthouse.json http://localhost:3000

# Bundle size check
bundlesize

# Performance budget check
node scripts/check-performance-budget.js

echo "✅ Performance Tests Complete!"
```

---

**Desenvolvido pelo GRUPO US VIBECODE SYSTEM V2.0**
