module.exports = {
  testEnvironment: "node",
  rootDir: "../..",
  testMatch: ["**/__tests__/**/*.test.js"], // Only run tests in __tests__ directory
  transform: {
    "^.+\\.(js|jsx|ts|tsx)$": "babel-jest",
  },
  transformIgnorePatterns: [
    "/node_modules/(?!(execa|is-plain-obj|figures|is-unicode-supported|yoctocolors|npm-run-path|path-key|human-signals|strip-final-newline|get-stream|is-stream|@sec-ant/readable-stream|pretty-ms|parse-ms|@sindresorhus/merge-streams)/)", // Transpile execa and its ES module dependencies
  ],
  moduleNameMapper: {
    "^unicorn-magic$":
      "<rootDir>/@project-core/tools/__mocks__/unicorn-magic.js",
  },
  // Add more Jest configurations here as needed
  // For example, to collect coverage:
  // collectCoverage: true,
  // coverageDirectory: 'coverage',
  // coverageReporters: ['json', 'lcov', 'text', 'clover'],
};
