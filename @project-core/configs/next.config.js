/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
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

module.exports = nextConfig;
