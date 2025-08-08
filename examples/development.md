# Development Workflow Examples

Real-world examples of how developers use Catclip to streamline their daily workflows.

## 🚀 Getting Started Examples

### Your First Day with Catclip

```bash
# Copy your project's README to share with teammates
catclip README.md
# ✅ Contents of 'README.md' copied to clipboard using xclip

# Copy configuration file for documentation
catclip config.json

# Look at what you've copied
clipshow
# 📋 Current clipboard contents:
# {
#   "database": "postgresql://...",
#   "redis": "redis://localhost:6379"
# }
# 📊 Stats: 12 lines, 45 words, 234 characters
```

### Learning the Commands

```bash
# Copy multiple related files at once
catclip src/models.py src/views.py src/serializers.py
# ✅ Contents of 3 files copied to clipboard: src/models.py src/views.py src/serializers.py

# Copy specific lines from a file
catclipn src/main.py 25 50
# ✅ Lines 25-50 from 'src/main.py' copied to clipboard using xclip

# Copy with line numbers for code review
catclipl src/complex_function.py
# ✅ Contents of 'src/complex_function.py' with line numbers copied to clipboard

# Copy and show on screen simultaneously
catclips important_config.yml
# [displays file content]
# ✅ Contents of 'important_config.yml' copied to clipboard using xclip

# Copy current directory path
pwdclip
# ✅ Current directory path copied to clipboard: /home/dev/myproject

# Copy directory listing
lsclip -la
# ✅ Directory listing (ls -la) copied to clipboard using xclip
```

## 🔄 Daily Development Workflows

### Morning Routine

```bash
#!/bin/bash
# morning_dev_setup.sh

echo "🌅 Good morning! Setting up your development workspace..."

# Copy today's tasks
catclip TODO.md
echo "📋 Today's tasks copied to clipboard"

# Copy current branch info
git branch --show-current | catclip
echo "🌿 Current branch copied to clipboard"

# Copy recent changes for standup
git log --oneline -5 | catclip
echo "📝 Recent commits copied for standup"

# Show usage insights from yesterday
catclip --insights
```

### Code Review Workflow

```bash
#!/bin/bash
# code_review.sh

PR_BRANCH="$1"
if [ -z "$PR_BRANCH" ]; then
    echo "Usage: ./code_review.sh <branch-name>"
    exit 1
fi

echo "🔍 Preparing code review for branch: $PR_BRANCH"

# Copy list of changed files
echo "📁 Changed files:"
git diff main..$PR_BRANCH --name-only | catclip
echo "File list copied to clipboard"

# Copy the diff for detailed review
echo "🔄 Creating detailed diff..."
git diff main..$PR_BRANCH > review_diff.txt
catclip review_diff.txt
echo "Detailed diff copied to clipboard"

# Copy commit messages
echo "📝 Commit messages:"
git log main..$PR_BRANCH --oneline | catclip
echo "Commit messages copied to clipboard"

# Copy test results if available
if [ -f "test_results.txt" ]; then
    catclip test_results.txt
    echo "✅ Test results copied to clipboard"
fi

# Clean up
rm -f review_diff.txt

echo "🎉 Code review prep complete! Check your clipboard."
```

### Bug Investigation Workflow

```bash
#!/bin/bash
# bug_investigation.sh

BUG_ID="$1"
echo "🐛 Investigating bug: $BUG_ID"

# Create investigation directory
mkdir -p "bug_investigations/$BUG_ID"
cd "bug_investigations/$BUG_ID"

# Copy error logs
if [ -f "../../logs/error.log" ]; then
    echo "📋 Copying recent error logs..."
    tail -n 100 ../../logs/error.log > recent_errors.log
    catclip recent_errors.log
    echo "Recent errors copied to clipboard"
fi

# Copy relevant source files
echo "📝 Copying potentially affected files..."
find ../../src -name "*.py" -mtime -7 | head -5 | xargs catclip
echo "Recently modified source files copied"

# Copy test files related to the bug
if [ -d "../../tests" ]; then
    echo "🧪 Looking for related tests..."
    find ../../tests -name "*test*.py" | head -3 | xargs catclip
    echo "Test files copied to clipboard"
fi

# Copy database query logs if available
if [ -f "../../logs/queries.log" ]; then
    echo "🗄️ Copying database queries..."
    catclipn ../../logs/queries.log -50 0  # Last 50 lines
    echo "Recent database queries copied"
fi

echo "🎯 Bug investigation files prepared!"
echo "Next steps:"
echo "1. Paste error logs into bug tracker"
echo "2. Review source code changes"
echo "3. Check test coverage"
```

## 🛠️ Project-Specific Workflows

### Django Project Workflow

```bash
#!/bin/bash
# django_workflow.sh

echo "🐍 Django development workflow"

# Copy models for documentation
echo "📊 Copying models..."
catclip myapp/models.py
echo "Models copied - paste into documentation"

# Copy views with line numbers for code review
echo "👀 Copying views with line numbers..."
catclipl myapp/views.py
echo "Views with line numbers copied"

# Copy serializers for API documentation
echo "🔄 Copying serializers..."
catclip myapp/serializers.py
echo "Serializers copied - ready for API docs"

# Copy URLs for routing documentation
echo "🛣️ Copying URL configuration..."
catclip myapp/urls.py config/urls.py
echo "URL configurations copied"

# Copy settings for deployment
echo "⚙️ Copying settings..."
catclip config/settings/development.py
echo "Development settings copied"

# Copy requirements
echo "📦 Copying requirements..."
catclip requirements.txt
echo "Requirements copied for environment setup"

echo "✨ Django files ready in clipboard!"
```

### Node.js/JavaScript Workflow

```bash
#!/bin/bash
# nodejs_workflow.sh

echo "📦 Node.js development workflow"

# Copy package.json for dependency review
catclip package.json
echo "📋 Package.json copied - ready to share dependencies"

# Copy main application files
echo "🔧 Copying main application files..."
catclip src/app.js src/routes/*.js
echo "Main application files copied"

# Copy configuration files
echo "⚙️ Copying configuration..."
catclip .env.example config.js
echo "Configuration files copied"

# Copy tests
echo "🧪 Copying test files..."
catclip tests/*.test.js
echo "Test files copied"

# Copy deployment configuration
if [ -f "Dockerfile" ]; then
    catclip Dockerfile docker-compose.yml
    echo "🐳 Docker configuration copied"
fi

# Show current directory structure for documentation
lsclip -la
echo "📁 Directory structure copied"

echo "🚀 Node.js project files ready!"
```

### Python Data Science Workflow

```bash
#!/bin/bash
# datascience_workflow.sh

echo "📊 Data Science workflow with Catclip"

# Copy Jupyter notebook as Python script
if [ -f "analysis.ipynb" ]; then
    jupyter nbconvert --to python analysis.ipynb --stdout | catclip
    echo "📓 Jupyter notebook converted and copied as Python script"
fi

# Copy data processing scripts
echo "🔄 Copying data processing scripts..."
catclip src/data_processing.py src/visualization.py
echo "Data processing scripts copied"

# Copy model training results
if [ -f "model_results.txt" ]; then
    catclip model_results.txt
    echo "🤖 Model training results copied"
fi

# Copy requirements for reproducible environment
catclip requirements.txt environment.yml
echo "📦 Environment files copied"

# Copy dataset description
if [ -f "data/README.md" ]; then
    catclip data/README.md
    echo "📋 Dataset description copied"
fi

echo "🔬 Data science files ready for sharing!"
```

## 🏢 Team Collaboration Examples

### Sprint Planning Workflow

```bash
#!/bin/bash
# sprint_planning.sh

SPRINT_NUMBER="$1"
echo "🏃‍♂️ Sprint $SPRINT_NUMBER planning workflow"

# Copy user stories
if [ -f "user_stories.md" ]; then
    catclip user_stories.md
    echo "📖 User stories copied for planning meeting"
fi

# Copy technical debt items
if [ -f "technical_debt.md" ]; then
    catclip technical_debt.md
    echo "🔧 Technical debt items copied"
fi

# Copy performance metrics
if [ -f "performance_report.md" ]; then
    catclip performance_report.md
    echo "📈 Performance metrics copied"
fi

# Copy team capacity
echo "Team Capacity for Sprint $SPRINT_NUMBER" > sprint_capacity.txt
echo "=================================" >> sprint_capacity.txt
echo "Available story points: 40" >> sprint_capacity.txt
echo "Team members: 4" >> sprint_capacity.txt
echo "Sprint duration: 2 weeks" >> sprint_capacity.txt
catclip sprint_capacity.txt
echo "👥 Team capacity copied"

# Copy previous sprint retrospective
if [ -f "sprint_$((SPRINT_NUMBER-1))_retro.md" ]; then
    catclip "sprint_$((SPRINT_NUMBER-1))_retro.md"
    echo "🔄 Previous sprint retrospective copied"
fi

rm -f sprint_capacity.txt
echo "🎯 Sprint planning materials ready!"
```

### Knowledge Sharing Workflow

```bash
#!/bin/bash
# knowledge_sharing.sh

TOPIC="$1"
echo "🧠 Knowledge sharing: $TOPIC"

# Copy code examples
echo "📝 Preparing code examples..."
catclip examples/*.py examples/*.js
echo "Code examples copied"

# Copy documentation
if [ -f "docs/$TOPIC.md" ]; then
    catclip "docs/$TOPIC.md"
    echo "📚 Documentation copied"
fi

# Copy best practices
if [ -f "best_practices/$TOPIC.md" ]; then
    catclip "best_practices/$TOPIC.md"
    echo "⭐ Best practices copied"
fi

# Copy common pitfalls
if [ -f "common_pitfalls/$TOPIC.md" ]; then
    catclip "common_pitfalls/$TOPIC.md"
    echo "⚠️ Common pitfalls copied"
fi

# Generate learning checklist
echo "# $TOPIC Learning Checklist" > learning_checklist.md
echo "" >> learning_checklist.md
echo "## Prerequisites" >> learning_checklist.md
echo "- [ ] Basic understanding of..." >> learning_checklist.md
echo "" >> learning_checklist.md
echo "## Key Concepts" >> learning_checklist.md
echo "- [ ] Concept 1" >> learning_checklist.md
echo "- [ ] Concept 2" >> learning_checklist.md
echo "" >> learning_checklist.md
echo "## Hands-on Practice" >> learning_checklist.md
echo "- [ ] Complete example 1" >> learning_checklist.md
echo "- [ ] Complete example 2" >> learning_checklist.md

catclip learning_checklist.md
echo "✅ Learning checklist created and copied"

rm -f learning_checklist.md
echo "🎓 Knowledge sharing materials ready!"
```

## 🔧 Advanced Automation Examples

### Smart File Copying Based on Context

```bash
#!/bin/bash
# smart_copy.sh

# Function to intelligently copy files based on current context
smart_copy() {
    local current_dir=$(basename $(pwd))
    local file_pattern="$1"
    
    echo "🧠 Smart copying in context: $current_dir"
    
    case "$current_dir" in
        "frontend"|"client"|"ui")
            echo "🎨 Frontend context detected"
            catclip src/components/*.jsx src/styles/*.css package.json
            echo "Frontend files copied"
            ;;
        "backend"|"server"|"api")
            echo "🖥️ Backend context detected"
            catclip src/controllers/*.py src/models/*.py requirements.txt
            echo "Backend files copied"
            ;;
        "docs"|"documentation")
            echo "📚 Documentation context detected"
            catclip *.md assets/images/*.png
            echo "Documentation files copied"
            ;;
        "tests"|"testing")
            echo "🧪 Testing context detected"
            catclip tests/*.py tests/*.js conftest.py
            echo "Test files copied"
            ;;
        *)
            echo "📁 Generic context - copying common files"
            catclip README.md *.json *.yml
            echo "Common project files copied"
            ;;
    esac
}

# Usage: smart_copy
smart_copy
```

### Automated Documentation Generator

```bash
#!/bin/bash
# doc_generator.sh

echo "📖 Generating documentation with Catclip"

# Generate API documentation
generate_api_docs() {
    echo "🔌 Generating API documentation..."
    
    # Copy all API endpoint files
    find . -name "*routes*.py" -o -name "*views*.py" -o -name "*endpoints*.py" | xargs catclip
    echo "API endpoint files copied"
    
    # Copy API models
    find . -name "*models*.py" -o -name "*schemas*.py" | head -5 | xargs catclip
    echo "API models copied"
    
    # Copy API tests for examples
    find . -name "*test*api*.py" | head -3 | xargs catclip
    echo "API test files copied for examples"
}

# Generate README sections
generate_readme_sections() {
    echo "📝 Generating README sections..."
    
    # Installation section
    if [ -f "requirements.txt" ] || [ -f "package.json" ]; then
        echo "## Installation" > readme_section.md
        echo "" >> readme_section.md
        if [ -f "requirements.txt" ]; then
            echo "\`\`\`bash" >> readme_section.md
            echo "pip install -r requirements.txt" >> readme_section.md
            echo "\`\`\`" >> readme_section.md
        fi
        if [ -f "package.json" ]; then
            echo "\`\`\`bash" >> readme_section.md
            echo "npm install" >> readme_section.md
            echo "\`\`\`" >> readme_section.md
        fi
        catclip readme_section.md
        echo "Installation section copied"
        rm -f readme_section.md
    fi
    
    # Usage examples
    if [ -d "examples" ]; then
        catclip examples/*.md examples/*.py examples/*.js 2>/dev/null
        echo "Usage examples copied"
    fi
}

# Generate changelog
generate_changelog() {
    echo "📅 Generating changelog..."
    
    # Get recent commits
    git log --oneline --since="1 month ago" > recent_changes.txt
    catclip recent_changes.txt
    echo "Recent changes copied"
    rm -f recent_changes.txt
}

# Main documentation generation
main() {
    generate_api_docs
    generate_readme_sections
    generate_changelog
    
    echo "✨ Documentation generation complete!"
    echo "Check your clipboard for generated content"
}

main "$@"
```

### Deployment Workflow

```bash
#!/bin/bash
# deployment_workflow.sh

ENVIRONMENT="$1"
if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: ./deployment_workflow.sh <staging|production>"
    exit 1
fi

echo "🚀 Deployment workflow for: $ENVIRONMENT"

# Copy environment configuration
copy_environment_config() {
    echo "⚙️ Copying environment configuration..."
    
    if [ -f "config/$ENVIRONMENT.yml" ]; then
        catclip "config/$ENVIRONMENT.yml"
        echo "$ENVIRONMENT configuration copied"
    fi
    
    if [ -f ".env.$ENVIRONMENT" ]; then
        catclip ".env.$ENVIRONMENT"
        echo "$ENVIRONMENT environment variables copied"
    fi
}

# Copy deployment scripts
copy_deployment_scripts() {
    echo "📋 Copying deployment scripts..."
    
    if [ -f "deploy/$ENVIRONMENT.sh" ]; then
        catclip "deploy/$ENVIRONMENT.sh"
        echo "Deployment script copied"
    fi
    
    if [ -f "docker-compose.$ENVIRONMENT.yml" ]; then
        catclip "docker-compose.$ENVIRONMENT.yml"
        echo "Docker compose configuration copied"
    fi
    
    if [ -f "k8s/$ENVIRONMENT/*.yml" ]; then
        catclip k8s/$ENVIRONMENT/*.yml
        echo "Kubernetes configuration copied"
    fi
}

# Copy database migration scripts
copy_migration_scripts() {
    echo "🗄️ Copying migration scripts..."
    
    if [ -d "migrations" ]; then
        find migrations -name "*.sql" -newer migrations/.last_deploy 2>/dev/null | xargs catclip
        echo "New migration scripts copied"
    fi
}

# Generate deployment checklist
generate_checklist() {
    echo "✅ Generating deployment checklist..."
    
    cat > deployment_checklist.md << EOF
# $ENVIRONMENT Deployment Checklist

## Pre-deployment
- [ ] All tests pass
- [ ] Code review completed
- [ ] Database migrations ready
- [ ] Configuration updated
- [ ] Backup created

## Deployment
- [ ] Stop services
- [ ] Deploy new code
- [ ] Run migrations
- [ ] Update configuration
- [ ] Start services

## Post-deployment
- [ ] Health checks pass
- [ ] Monitoring alerts cleared
- [ ] Smoke tests completed
- [ ] Rollback plan ready

## Rollback (if needed)
- [ ] Stop new services
- [ ] Restore previous version
- [ ] Rollback database
- [ ] Verify functionality
EOF
    
    catclip deployment_checklist.md
    echo "Deployment checklist copied"
    rm -f deployment_checklist.md
}

# Main deployment workflow
main() {
    copy_environment_config
    copy_deployment_scripts
    copy_migration_scripts
    generate_checklist
    
    echo "📦 Deployment workflow complete!"
    echo "All necessary files copied to clipboard"
    
    # Show deployment insights
    echo ""
    echo "📊 Recent deployment activity:"
    catclip --insights | grep -i deploy || echo "No deployment metrics available"
}

main
```

## 📊 Analytics and Insights Examples

### Understanding Your Workflow

```bash
#!/bin/bash
# workflow_analysis.sh

echo "📈 Analyzing your development workflow with Catclip"

# Show overall usage insights
echo "=== Overall Usage Patterns ==="
catclip --insights

# Show performance statistics
echo -e "\n=== Performance Statistics ==="
catclip --stats

# Analyze most copied file types
echo -e "\n=== Most Copied File Types ==="
if [ -f ~/.catclip.history ]; then
    echo "Analyzing your clipboard history..."
    cut -d'|' -f5 ~/.catclip.history | tr ',' '\n' | sort | uniq -c | sort -nr | head -10
else
    echo "No history data available yet"
fi

# Analyze peak usage hours
echo -e "\n=== Peak Usage Hours ==="
if [ -f ~/.catclip.analytics ]; then
    echo "Your most productive clipboard hours:"
    cut -d'|' -f3 ~/.catclip.analytics | sort | uniq -c | sort -nr | head -5 | while read count hour; do
        echo "  ${hour}:00 - ${count} operations"
    done
else
    echo "No analytics data available yet"
fi

# Generate workflow recommendations
echo -e "\n=== Workflow Recommendations ==="
echo "Based on your usage patterns:"

# Check for repetitive patterns
if [ -f ~/.catclip.history ]; then
    repeated_files=$(cut -d'|' -f2 ~/.catclip.history | sort | uniq -d | wc -l)
    if [ "$repeated_files" -gt 5 ]; then
        echo "💡 You copy the same files frequently - consider creating aliases"
        echo "   Most repeated files:"
        cut -d'|' -f2 ~/.catclip.history | sort | uniq -c | sort -nr | head -3 | while read count file; do
            echo "   - $file ($count times)"
        done
    fi
    
    large_files=$(grep -c "large" ~/.catclip.history)
    if [ "$large_files" -gt 3 ]; then
        echo "⚠️  You often copy large files - consider using line ranges"
        echo "   Use: catclipn filename.txt 1 100"
    fi
fi

echo -e "\n✨ Analysis complete! Use these insights to optimize your workflow."
```

---

These examples demonstrate the **80-20 Human-in-the-Loop philosophy**:
- **80% automation**: Smart file detection, workflow context awareness, automatic insights
- **20% human control**: Conscious decisions about what to copy, when, and how to use it

Each workflow can be customized to match your specific development environment and team processes. The key is to let Catclip handle the repetitive tasks while you focus on the creative problem-solving that requires human insight.