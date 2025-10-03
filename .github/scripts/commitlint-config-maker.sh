
echo 'import { RuleConfigCondition, RuleConfigSeverity, TargetCaseType } from "@commitlint/types";' > commitlint.config.ts
echo '' >> commitlint.config.ts
echo 'export default {' >> commitlint.config.ts
echo '  parserPreset: "conventional-changelog-conventionalcommits",' >> commitlint.config.ts
echo '  rules: {' >> commitlint.config.ts
echo '    "body-leading-blank": [RuleConfigSeverity.Warning, "always"] as const,' >> commitlint.config.ts
echo '    "body-max-line-length": [RuleConfigSeverity.Error, "always", 100] as const,' >> commitlint.config.ts
echo '    "footer-leading-blank": [RuleConfigSeverity.Warning, "always"] as const,' >> commitlint.config.ts
echo '    "footer-max-line-length": [RuleConfigSeverity.Error, "always", 100] as const,' >> commitlint.config.ts
echo '    "header-max-length": [RuleConfigSeverity.Error, "always", 100] as const,' >> commitlint.config.ts
echo '    "header-trim": [RuleConfigSeverity.Error, "always"] as const,' >> commitlint.config.ts
echo '    "subject-case": [RuleConfigSeverity.Error, "never", ["sentence-case", "start-case", "pascal-case", "upper-case"]] as [RuleConfigSeverity, RuleConfigCondition, TargetCaseType[]],' >> commitlint.config.ts
echo '    "subject-empty": [RuleConfigSeverity.Error, "never"] as const,' >> commitlint.config.ts
echo '    "subject-full-stop": [RuleConfigSeverity.Error, "never", "."] as const,' >> commitlint.config.ts
echo '    "type-case": [RuleConfigSeverity.Error, "always", "lower-case"] as const,' >> commitlint.config.ts
echo '    "type-empty": [RuleConfigSeverity.Error, "never"] as const,' >> commitlint.config.ts
echo '    "type-enum": [RuleConfigSeverity.Error, "always", ["build", "chore", "ci", "docs", "feat", "fix", "perf", "refactor", "revert", "style", "test"]] as [RuleConfigSeverity, RuleConfigCondition, string[]],' >> commitlint.config.ts
echo '  },' >> commitlint.config.ts
echo '  prompt: {' >> commitlint.config.ts
echo '    questions: {' >> commitlint.config.ts
echo '      type: {' >> commitlint.config.ts
echo '        description: "Select the type of change that you'\''re committing",' >> commitlint.config.ts
echo '        enum: {' >> commitlint.config.ts
echo '          feat: { description: "A new feature", title: "Features", emoji: "✨" },' >> commitlint.config.ts
echo '          fix: { description: "A bug fix", title: "Bug Fixes", emoji: "🐛" },' >> commitlint.config.ts
echo '          docs: { description: "Documentation only changes", title: "Documentation", emoji: "📚" },' >> commitlint.config.ts
echo '          style: { description: "Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)", title: "Styles", emoji: "💎" },' >> commitlint.config.ts
echo '          refactor: { description: "A code change that neither fixes a bug nor adds a feature", title: "Code Refactoring", emoji: "📦" },' >> commitlint.config.ts
echo '          perf: { description: "A code change that improves performance", title: "Performance Improvements", emoji: "🚀" },' >> commitlint.config.ts
echo '          test: { description: "Adding missing tests or correcting existing tests", title: "Tests", emoji: "🚨" },' >> commitlint.config.ts
echo '          build: { description: "Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)", title: "Builds", emoji: "🛠" },' >> commitlint.config.ts
echo '          ci: { description: "Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)", title: "Continuous Integrations", emoji: "⚙️" },' >> commitlint.config.ts
echo '          chore: { description: "Other changes that don'\''t modify src or test files", title: "Chores", emoji: "♻️" },' >> commitlint.config.ts
echo '          revert: { description: "Reverts a previous commit", title: "Reverts", emoji: "🗑" },' >> commitlint.config.ts
echo '        },' >> commitlint.config.ts
echo '      },' >> commitlint.config.ts
echo '      scope: { description: "What is the scope of this change (e.g. component or file name)" },' >> commitlint.config.ts
echo '      subject: { description: "Write a short, imperative tense description of the change" },' >> commitlint.config.ts
echo '      body: { description: "Provide a longer description of the change" },' >> commitlint.config.ts
echo '      isBreaking: { description: "Are there any breaking changes?" },' >> commitlint.config.ts
echo '      breakingBody: { description: "A BREAKING CHANGE commit requires a body. Please enter a longer description of the commit itself" },' >> commitlint.config.ts
echo '      breaking: { description: "Describe the breaking changes" },' >> commitlint.config.ts
echo '      isIssueAffected: { description: "Does this change affect any open issues?" },' >> commitlint.config.ts
echo '      issuesBody: { description: "If issues are closed, the commit requires a body. Please enter a longer description of the commit itself" },' >> commitlint.config.ts
echo '      issues: { description: "Add issue references (e.g. \"fix #123\", \"re #123\".)" },' >> commitlint.config.ts
echo '    },' >> commitlint.config.ts
echo '  },' >> commitlint.config.ts
echo '};' >> commitlint.config.ts
