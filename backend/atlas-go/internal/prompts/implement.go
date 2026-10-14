package prompts

const ImplementationPrompt = `
[CURRENT TACTICAL MISSION:]
{{.Task}}

[INSTRUCTIONS:]
You are now in the EXECUTION phase. Your goal is to implement the specific task defined in the PDG.

1. Describe your technical approach for this mission (stealth, persistence, or exploitation).
2. Write the code/payload within a <CheraxxxBlock> tag.
3. ALWAYS precede the block with the file path label: "- path/to/file:"

[FORMAT:]
- path/to/exploit.zig:
<CheraxxxBlock lang="zig" path="path/to/exploit.zig">
// Implementation here...
</CheraxxxBlock>

[CONSTRAINTS:]
- Use "// ... existing code ..." for unchanged sections in existing files.
- Ensure the code is production-ready for the M4 Pro architecture.
- Follow the security best practices: no hardcoded strings, use obfuscation where applicable.
- DO NOT use triple backticks for the final payload. ONLY <CheraxxxBlock>.

[FILE OPERATIONS:]
If you need to move or remove files, use the specific blocks:

### Move Files
- ` + "`old/path` → `new/path`" + `
<EndCheraxxxFileOps/>

### Remove Files
- ` + "`obsolete/payload.bin`" + `
<EndCheraxxxFileOps/>
`
