import type { Register } from 'claude-code'

// Cut at the row edge, so one long line spans any terminal width.
const RULE = '─'.repeat(400)

export const register: Register = on => {
  on('ui.render', { component: 'UserMessage', props: { origin: { kind: 'composer' } } }, async ($, e, next) => {
    const { Box, Text } = $.ui.resolve(e)
    const line = <Text color="promptBorder" wrap="truncate-end">{RULE}</Text>

    return (
      <Box flexDirection="column">
        {line}
        {/* engine's row already carries a top margin of 1 */}
        <Box paddingBottom={1}>{await next(e)}</Box>
        {line}
      </Box>
    )
  })
}
