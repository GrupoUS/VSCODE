import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  experimental: {
    // PPR removed - only available in canary
    turbo: {
      rules: {
        "*.svg": {
          loaders: ["@svgr/webpack"],
          as: "*.js",
        },
      },
    },
  },
  images: {
    remotePatterns: [
      {
        hostname: "storage.supabase.co",
      },
    ],
  },
  // Healthcare-specific optimizations
  poweredByHeader: false,
  compress: true,
  // Enable strict mode for better performance
  reactStrictMode: true,
  // Optimize for production
  swcMinify: true,
};

export default nextConfig;
