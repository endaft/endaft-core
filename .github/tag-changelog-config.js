module.exports = {
  types: [
    { types: ['feat', 'feature'], label: '🎉 New Features' },
    { types: ['fix', 'bugfix', 'bug'], label: '🐛 Bugfixes' },
    { types: ['improvements', 'enhancement', 'impro', 'enhance'], label: '🔨 Improvements' },
    { types: ['perf'], label: '🏎️ Performance Improvements' },
    { types: ['build', 'ci', 'cd', 'workflow', 'cicd'], label: '🏗️ Build System' },
    { types: ['refactor', 'refac', 'ref'], label: '🪚 Refactors' },
    { types: ['doc', 'docs'], label: '📚 Documentation Changes' },
    { types: ['test', 'tests', 'quality'], label: '🔍 Tests' },
    { types: ['style', 'format'], label: '💅 Code Style Changes' },
    { types: ['chore'], label: '🧹 Chores' },
    { types: ['other'], label: '🤔 Other Changes' },
  ],

  excludeTypes: [],

  renderTypeSection: (label, commits) => `\n### ${label}\n\n${commits.map((c) => `- ${c.subject}`).join('\n')}`,

  renderChangelog: (release, changes) => `## ${release}\n\n` + changes + '\n\n',
};
