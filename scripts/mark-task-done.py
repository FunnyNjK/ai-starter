#!/usr/bin/env python3
"""Automate marking a task done.
Removes the task block from ai/TASKS.md and appends it to ai/DONE_LOG.md.
Usage: python3 scripts/mark-task-done.py <TASK-ID>
Example: python3 scripts/mark-task-done.py P0-T1
"""

import sys
import re
from datetime import datetime, timezone
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

def update_last_updated(lines, date_str):
    for i, line in enumerate(lines[:10]):
        if re.match(r"^Last Updated:\s*", line):
            lines[i] = f"Last Updated: {date_str}\n"
            return
    lines.insert(2, f"Last Updated: {date_str}\n\n")

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 scripts/mark-task-done.py <TASK-ID>")
        sys.exit(1)
        
    task_id = sys.argv[1].strip()
    tasks_path = REPO_ROOT / "ai/TASKS.md"
    done_path = REPO_ROOT / "ai/DONE_LOG.md"
    
    if not tasks_path.exists():
        print(f"Error: {tasks_path} not found.")
        sys.exit(1)
        
    with open(tasks_path, "r", encoding="utf-8") as f:
        task_lines = f.readlines()
        
    new_task_lines = []
    in_target_task = False
    task_title = ""
    
    for line in task_lines:
        if line.startswith(f"### {task_id}:"):
            in_target_task = True
            task_title = line.strip().replace(f"### {task_id}:", "").strip()
            continue
        if in_target_task:
            # Stop skipping when we hit the next task or a major section
            if line.startswith("### P") or line.startswith("## "):
                in_target_task = False
            else:
                continue
                
        new_task_lines.append(line)
        
    if not task_title:
        print(f"Error: Task {task_id} not found in {tasks_path}")
        sys.exit(1)
        
    # Clean up excessive newlines
    clean_task_lines = []
    for line in new_task_lines:
        if clean_task_lines and clean_task_lines[-1] == "\n" and line == "\n":
            continue
        clean_task_lines.append(line)
        
    date_str = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    update_last_updated(clean_task_lines, date_str)
    
    with open(tasks_path, "w", encoding="utf-8") as f:
        f.writelines(clean_task_lines)
        
    # Update DONE_LOG.md
    if done_path.exists():
        with open(done_path, "r", encoding="utf-8") as f:
            done_lines = f.readlines()
    else:
        done_lines = ["# Done Log\n\n", f"Last Updated: {date_str}\n\n"]
        
    update_last_updated(done_lines, date_str)
    
    date_heading = f"### {date_str}\n"
    found_date = False
    insert_idx = len(done_lines)
    
    for i, line in enumerate(done_lines):
        if line == date_heading:
            found_date = True
            insert_idx = i + 1
            break
        if line.startswith("### 20"): # Found an older date heading
            if not found_date:
                insert_idx = i
                break
                
    if not found_date:
        # Prepend a newline if needed
        if insert_idx > 0 and done_lines[insert_idx - 1] != "\n":
            done_lines.insert(insert_idx, "\n")
            insert_idx += 1
        done_lines.insert(insert_idx, date_heading)
        insert_idx += 1
        
    done_lines.insert(insert_idx, f"- {task_id}: {task_title}\n")
    
    with open(done_path, "w", encoding="utf-8") as f:
        f.writelines(done_lines)
        
    print(f"Successfully marked {task_id} done.")
    print(f"- Removed from TASKS.md")
    print(f"- Appended to DONE_LOG.md: {task_id}: {task_title}")

if __name__ == "__main__":
    main()
