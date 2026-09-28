# Development Guidelines

- Do not create or maintain the two standard project-local skills.
- Only open the VisionOS simulator after the build finishes; otherwise, it consumes too many system resources.
- If you are the main agent, you should not implement features or fix bugs yourself. Instead, you should assign work to proper subagents. Reuse existing subagents if their previous work / contexts match the incoming task. The main agent should focus on planning and validation. If not specified otherwise, all subagents should use GPT-6 Astra model + medium reasoning effort.
