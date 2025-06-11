#!/usr/bin/env python3
"""
CodeChats Cache Generator for Claude Code
Global English Version
Author: Maugus LCO
"""

import json
import os
import re
from pathlib import Path
from datetime import datetime, timedelta

def clean_string(s):
    """Clean string for JSON compatibility"""
    if not s:
        return "CodeChat without initial message"
    
    # Remove control characters
    s = re.sub(r'[\x00-\x1F\x7F]', '', s)
    # Remove extra whitespace
    s = ' '.join(s.split())
    # Limit length
    s = s[:80]
    
    return s if s else "CodeChat without initial message"

def main():
    cache_file = Path.home() / ".claude/temp/codechats_cache.json"
    projects_dir = Path.home() / ".claude/projects"
    
    conversations = []
    
    for jsonl_file in projects_dir.glob("**/*.jsonl"):
        session_id = jsonl_file.stem
        project_path = str(jsonl_file.parent).replace(str(projects_dir) + "/", "")
        
        # Count lines
        try:
            with open(jsonl_file, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()
            message_count = len(lines)
        except:
            message_count = 0
            
        # Get first timestamp and message
        timestamp = "null"
        first_message = "CodeChat without initial message"
        
        if lines:
            try:
                first_line = json.loads(lines[0])
                timestamp = first_line.get('timestamp', 'null')
            except:
                pass
            
            # Find first user message
            for line in lines:
                try:
                    data = json.loads(line)
                    if data.get('type') == 'user':
                        content = data.get('message', {}).get('content', '')
                        if content and content != '':
                            first_message = clean_string(content)
                            break
                except:
                    continue
        
        # Determine recency
        recency = "old"
        if timestamp != "null":
            try:
                conv_date = datetime.fromisoformat(timestamp.replace('Z', '+00:00')).date()
                today = datetime.now().date()
                week_ago = today - timedelta(days=7)
                
                if conv_date == today:
                    recency = "today"
                elif conv_date >= week_ago:
                    recency = "week"
            except:
                pass
        
        conversations.append({
            "session_id": session_id,
            "project_path": project_path,
            "timestamp": timestamp,
            "message_count": message_count,
            "first_message": first_message,
            "recency": recency
        })
    
    # Sort by timestamp (newest first)
    conversations.sort(key=lambda x: x['timestamp'] if x['timestamp'] != "null" else "", reverse=True)
    
    # Write cache file
    with open(cache_file, 'w', encoding='utf-8') as f:
        json.dump(conversations, f, indent=2, ensure_ascii=False)
    
    print(f"✅ Cache created with {len(conversations)} CodeChats")

if __name__ == "__main__":
    main()