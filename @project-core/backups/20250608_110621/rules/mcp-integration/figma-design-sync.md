# 🎨 FIGMA DESIGN SYNC PROTOCOL - GRUPO US VIBECODE SYSTEM V2.0

## 📋 OVERVIEW

Comprehensive protocol for Figma integration, enabling seamless design-to-code workflows, component generation, and visual validation for maintaining design system consistency.

## 🚀 FIGMA SETUP & CONFIGURATION

### **Installation & Initialization**
```bash
# Install Figma MCP integration
npm run figma:install

# Start Figma MCP server
npm run figma:mcp

# Test Figma integration
npm run figma:test

# Test visual validation
npm run figma:visual-test
```

### **Environment Configuration**
```bash
# .env.figma configuration
FIGMA_API_KEY=your_figma_api_key_here
FIGMA_TEAM_ID=your_team_id
FIGMA_PROJECT_ID=your_project_id
FIGMA_COMPONENT_LIBRARY_ID=your_component_library_id
FIGMA_EXPORT_FORMAT=svg
FIGMA_EXPORT_SCALE=2
FIGMA_OUTPUT_PATH=./src/components/generated
```

### **API Key Setup**
1. Go to Figma → Settings → Account → Personal Access Tokens
2. Generate new token with appropriate permissions
3. Add token to environment variables
4. Verify access with test command

## 🎯 FIGMA INTEGRATION ACTIVATION

### **Mandatory Integration Scenarios:**
- **Component Generation**: Convert Figma components to React/Vue components
- **Design Validation**: Verify implementation matches design
- **Asset Extraction**: Export icons, images, and design tokens
- **Design System Sync**: Maintain consistency with design system
- **Visual Regression Testing**: Detect unintended design changes

### **Workflow Integration:**
- **Design Handoff**: Automated component generation from designs
- **Code Review**: Visual validation during PR reviews
- **Design Updates**: Sync design changes with code implementation
- **Style Guide Maintenance**: Keep design tokens synchronized

## 🏗️ FIGMA MCP MANAGER ARCHITECTURE

### **Core Figma Manager Class**
```javascript
class FigmaMCPManager {
    constructor(config = {}) {
        this.apiKey = config.apiKey || process.env.FIGMA_API_KEY;
        this.baseUrl = 'https://api.figma.com/v1';
        this.config = {
            exportFormat: config.exportFormat || 'svg',
            exportScale: config.exportScale || 2,
            outputPath: config.outputPath || './src/components/generated',
            ...config
        };
        
        this.cache = new Map();
        this.rateLimiter = new RateLimiter(100, 60000); // 100 requests per minute
    }

    async getFileData(fileKey, nodeId = null) {
        const cacheKey = `file-${fileKey}-${nodeId || 'root'}`;
        
        if (this.cache.has(cacheKey)) {
            return this.cache.get(cacheKey);
        }

        await this.rateLimiter.wait();
        
        const url = nodeId 
            ? `${this.baseUrl}/files/${fileKey}/nodes?ids=${nodeId}`
            : `${this.baseUrl}/files/${fileKey}`;
            
        const response = await fetch(url, {
            headers: {
                'X-Figma-Token': this.apiKey
            }
        });
        
        if (!response.ok) {
            throw new Error(`Figma API error: ${response.status} ${response.statusText}`);
        }
        
        const data = await response.json();
        this.cache.set(cacheKey, data);
        
        return data;
    }

    async getComponentData(fileKey, nodeId) {
        const data = await this.getFileData(fileKey, nodeId);
        const node = data.nodes[nodeId];
        
        if (!node) {
            throw new Error(`Node ${nodeId} not found in file ${fileKey}`);
        }
        
        return this.parseComponentData(node.document);
    }

    parseComponentData(node) {
        return {
            id: node.id,
            name: node.name,
            type: node.type,
            styles: this.extractStyles(node),
            children: node.children ? node.children.map(child => this.parseComponentData(child)) : [],
            constraints: node.constraints,
            effects: node.effects,
            fills: node.fills,
            strokes: node.strokes,
            cornerRadius: node.cornerRadius,
            size: {
                width: node.absoluteBoundingBox?.width,
                height: node.absoluteBoundingBox?.height
            }
        };
    }

    extractStyles(node) {
        const styles = {};
        
        // Extract typography
        if (node.style) {
            styles.typography = {
                fontFamily: node.style.fontFamily,
                fontSize: node.style.fontSize,
                fontWeight: node.style.fontWeight,
                lineHeight: node.style.lineHeightPx,
                letterSpacing: node.style.letterSpacing,
                textAlign: node.style.textAlignHorizontal?.toLowerCase()
            };
        }
        
        // Extract colors
        if (node.fills && node.fills.length > 0) {
            styles.backgroundColor = this.convertFigmaColor(node.fills[0]);
        }
        
        if (node.strokes && node.strokes.length > 0) {
            styles.borderColor = this.convertFigmaColor(node.strokes[0]);
            styles.borderWidth = node.strokeWeight || 1;
        }
        
        // Extract layout
        styles.layout = {
            width: node.absoluteBoundingBox?.width,
            height: node.absoluteBoundingBox?.height,
            padding: this.extractPadding(node),
            margin: this.extractMargin(node)
        };
        
        return styles;
    }

    convertFigmaColor(fill) {
        if (fill.type === 'SOLID') {
            const { r, g, b, a = 1 } = fill.color;
            return `rgba(${Math.round(r * 255)}, ${Math.round(g * 255)}, ${Math.round(b * 255)}, ${a})`;
        }
        return 'transparent';
    }
}
```

### **Component Code Generation**
```javascript
class FigmaComponentGenerator {
    constructor(figmaManager) {
        this.figmaManager = figmaManager;
        this.templates = {
            react: this.getReactTemplate(),
            vue: this.getVueTemplate(),
            angular: this.getAngularTemplate()
        };
    }

    async generateComponentCode(componentData, framework = 'react') {
        const template = this.templates[framework];
        if (!template) {
            throw new Error(`Unsupported framework: ${framework}`);
        }

        const componentCode = template(componentData);
        const styledCode = this.generateStyledComponents(componentData);
        const testCode = this.generateTestCode(componentData, framework);

        return {
            component: componentCode,
            styles: styledCode,
            test: testCode,
            types: this.generateTypeDefinitions(componentData)
        };
    }

    getReactTemplate() {
        return (data) => `
import React from 'react';
import styled from 'styled-components';
import { ${this.pascalCase(data.name)}Props } from './${this.kebabCase(data.name)}.types';

const ${this.pascalCase(data.name)}Container = styled.div\`
  ${this.generateCSS(data.styles)}
\`;

export const ${this.pascalCase(data.name)}: React.FC<${this.pascalCase(data.name)}Props> = ({
  children,
  className,
  ...props
}) => {
  return (
    <${this.pascalCase(data.name)}Container className={className} {...props}>
      ${this.generateChildComponents(data.children)}
      {children}
    </${this.pascalCase(data.name)}Container>
  );
};

export default ${this.pascalCase(data.name)};
`;
    }

    generateCSS(styles) {
        let css = '';
        
        if (styles.layout) {
            if (styles.layout.width) css += `width: ${styles.layout.width}px;\n  `;
            if (styles.layout.height) css += `height: ${styles.layout.height}px;\n  `;
        }
        
        if (styles.backgroundColor) {
            css += `background-color: ${styles.backgroundColor};\n  `;
        }
        
        if (styles.borderColor) {
            css += `border: ${styles.borderWidth || 1}px solid ${styles.borderColor};\n  `;
        }
        
        if (styles.typography) {
            const typo = styles.typography;
            if (typo.fontFamily) css += `font-family: '${typo.fontFamily}';\n  `;
            if (typo.fontSize) css += `font-size: ${typo.fontSize}px;\n  `;
            if (typo.fontWeight) css += `font-weight: ${typo.fontWeight};\n  `;
            if (typo.lineHeight) css += `line-height: ${typo.lineHeight}px;\n  `;
            if (typo.textAlign) css += `text-align: ${typo.textAlign};\n  `;
        }
        
        return css.trim();
    }

    generateTestCode(componentData, framework) {
        if (framework === 'react') {
            return `
import { render, screen } from '@testing-library/react';
import { ${this.pascalCase(componentData.name)} } from './${this.kebabCase(componentData.name)}';

describe('${this.pascalCase(componentData.name)}', () => {
  it('renders without crashing', () => {
    render(<${this.pascalCase(componentData.name)} />);
  });

  it('applies custom className', () => {
    const customClass = 'custom-class';
    render(<${this.pascalCase(componentData.name)} className={customClass} />);
    
    const element = screen.getByRole('generic');
    expect(element).toHaveClass(customClass);
  });

  it('renders children content', () => {
    const testContent = 'Test content';
    render(<${this.pascalCase(componentData.name)}>{testContent}</${this.pascalCase(componentData.name)}>);
    
    expect(screen.getByText(testContent)).toBeInTheDocument();
  });
});
`;
        }
        return '';
    }

    generateTypeDefinitions(componentData) {
        return `
export interface ${this.pascalCase(componentData.name)}Props {
  children?: React.ReactNode;
  className?: string;
  ${this.generatePropTypes(componentData)}
}
`;
    }

    pascalCase(str) {
        return str.replace(/(?:^\w|[A-Z]|\b\w)/g, (word, index) => {
            return index === 0 ? word.toLowerCase() : word.toUpperCase();
        }).replace(/\s+/g, '');
    }

    kebabCase(str) {
        return str.replace(/([a-z])([A-Z])/g, '$1-$2').toLowerCase();
    }
}
```

## 🔄 DESIGN-TO-CODE WORKFLOW

### **Automated Component Generation**
```javascript
async function generateComponentFromFigma(figmaUrl, outputPath) {
    const figmaManager = new FigmaMCPManager();
    const generator = new FigmaComponentGenerator(figmaManager);
    
    try {
        // Parse Figma URL to extract file key and node ID
        const { fileKey, nodeId } = parseFigmaUrl(figmaUrl);
        
        // Get component data from Figma
        const componentData = await figmaManager.getComponentData(fileKey, nodeId);
        
        // Generate component code
        const generatedCode = await generator.generateComponentCode(componentData, 'react');
        
        // Write files
        const componentName = generator.kebabCase(componentData.name);
        const basePath = path.join(outputPath, componentName);
        
        fs.mkdirSync(basePath, { recursive: true });
        
        fs.writeFileSync(
            path.join(basePath, `${componentName}.tsx`),
            generatedCode.component
        );
        
        fs.writeFileSync(
            path.join(basePath, `${componentName}.test.tsx`),
            generatedCode.test
        );
        
        fs.writeFileSync(
            path.join(basePath, `${componentName}.types.ts`),
            generatedCode.types
        );
        
        fs.writeFileSync(
            path.join(basePath, 'index.ts'),
            `export { default } from './${componentName}';\nexport * from './${componentName}.types';`
        );
        
        console.log(`✅ Component generated: ${basePath}`);
        
        return {
            success: true,
            componentPath: basePath,
            files: [
                `${componentName}.tsx`,
                `${componentName}.test.tsx`,
                `${componentName}.types.ts`,
                'index.ts'
            ]
        };
    } catch (error) {
        console.error('❌ Component generation failed:', error);
        return { success: false, error: error.message };
    }
}
```

### **Visual Validation Workflow**
```javascript
class FigmaVisualValidator {
    constructor(figmaManager, playwrightAutomation) {
        this.figmaManager = figmaManager;
        this.automation = playwrightAutomation;
    }

    async validateImplementation(figmaUrl, implementationUrl, options = {}) {
        const { threshold = 0.1, outputPath = './visual-tests' } = options;
        
        try {
            // Get Figma design
            const { fileKey, nodeId } = parseFigmaUrl(figmaUrl);
            const designImage = await this.figmaManager.exportImage(fileKey, nodeId);
            
            // Capture implementation screenshot
            await this.automation.initialize();
            await this.automation.page.goto(implementationUrl);
            
            const implementationImage = await this.automation.page.screenshot({
                fullPage: true,
                path: path.join(outputPath, 'implementation.png')
            });
            
            // Compare images
            const comparison = await this.compareImages(
                designImage,
                implementationImage,
                threshold
            );
            
            // Generate report
            const report = {
                figmaUrl,
                implementationUrl,
                similarity: comparison.similarity,
                passed: comparison.similarity >= (1 - threshold),
                differences: comparison.differences,
                timestamp: new Date().toISOString()
            };
            
            // Save report
            fs.writeFileSync(
                path.join(outputPath, 'validation-report.json'),
                JSON.stringify(report, null, 2)
            );
            
            return report;
        } catch (error) {
            console.error('Visual validation failed:', error);
            throw error;
        } finally {
            await this.automation.cleanup();
        }
    }

    async compareImages(image1, image2, threshold) {
        // Use image comparison library (e.g., pixelmatch)
        const img1 = PNG.sync.read(image1);
        const img2 = PNG.sync.read(image2);
        
        const { width, height } = img1;
        const diff = new PNG({ width, height });
        
        const numDiffPixels = pixelmatch(
            img1.data,
            img2.data,
            diff.data,
            width,
            height,
            { threshold: 0.1 }
        );
        
        const totalPixels = width * height;
        const similarity = 1 - (numDiffPixels / totalPixels);
        
        return {
            similarity,
            differences: numDiffPixels,
            totalPixels,
            diffImage: PNG.sync.write(diff)
        };
    }
}
```

## 📊 DESIGN SYSTEM SYNC

### **Design Token Extraction**
```javascript
async function extractDesignTokens(fileKey) {
    const figmaManager = new FigmaMCPManager();
    
    try {
        const fileData = await figmaManager.getFileData(fileKey);
        const tokens = {
            colors: {},
            typography: {},
            spacing: {},
            shadows: {},
            borderRadius: {}
        };
        
        // Extract color styles
        if (fileData.styles) {
            for (const [styleId, style] of Object.entries(fileData.styles)) {
                if (style.styleType === 'FILL') {
                    tokens.colors[style.name] = figmaManager.convertFigmaColor(style);
                }
            }
        }
        
        // Extract text styles
        if (fileData.styles) {
            for (const [styleId, style] of Object.entries(fileData.styles)) {
                if (style.styleType === 'TEXT') {
                    tokens.typography[style.name] = {
                        fontFamily: style.fontFamily,
                        fontSize: style.fontSize,
                        fontWeight: style.fontWeight,
                        lineHeight: style.lineHeight
                    };
                }
            }
        }
        
        // Generate CSS custom properties
        const cssTokens = generateCSSTokens(tokens);
        
        // Generate JavaScript tokens
        const jsTokens = generateJSTokens(tokens);
        
        return {
            tokens,
            css: cssTokens,
            javascript: jsTokens
        };
    } catch (error) {
        console.error('Design token extraction failed:', error);
        throw error;
    }
}

function generateCSSTokens(tokens) {
    let css = ':root {\n';
    
    // Colors
    for (const [name, value] of Object.entries(tokens.colors)) {
        css += `  --color-${kebabCase(name)}: ${value};\n`;
    }
    
    // Typography
    for (const [name, style] of Object.entries(tokens.typography)) {
        css += `  --font-${kebabCase(name)}-family: ${style.fontFamily};\n`;
        css += `  --font-${kebabCase(name)}-size: ${style.fontSize}px;\n`;
        css += `  --font-${kebabCase(name)}-weight: ${style.fontWeight};\n`;
        css += `  --font-${kebabCase(name)}-line-height: ${style.lineHeight};\n`;
    }
    
    css += '}';
    return css;
}
```

## 🧪 TESTING & VALIDATION

### **Figma Integration Tests**
```bash
# Test Figma API connection
npm run figma:test

# Test component generation
npm run figma:generate-test

# Test visual validation
npm run figma:visual-test

# Test design token extraction
npm run figma:tokens-test
```

### **Automated Testing Pipeline**
```javascript
async function runFigmaIntegrationTests() {
    const tests = [
        testFigmaAPIConnection,
        testComponentGeneration,
        testVisualValidation,
        testDesignTokenExtraction
    ];
    
    const results = [];
    
    for (const test of tests) {
        try {
            const result = await test();
            results.push({ test: test.name, success: true, ...result });
        } catch (error) {
            results.push({ test: test.name, success: false, error: error.message });
        }
    }
    
    return results;
}
```

---

**This protocol ensures seamless Figma integration for design-to-code workflows, maintaining design system consistency and enabling efficient collaboration between design and development teams.**
