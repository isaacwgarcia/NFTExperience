/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  env: {
    INFURA_IPFS: process.env.INFURA_IPFS,
  },
};

module.exports = nextConfig;
