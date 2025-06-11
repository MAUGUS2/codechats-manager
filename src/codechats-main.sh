#!/bin/bash

# Interactive CodeChats Manager for Claude Code
# Author: MAUGUS ✌️
# Usage: codechats
# Global English Version

# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Unicode symbols
FOLDER="📁"
FIRE="🔥"
LIGHTNING="⚡"
BOOK="📚"
TARGET="🎯"
GLOBE="🌐"
SEARCH="🔍"
BACK="⬅️"
MENU="📋"

# Temporary state files
STATE_DIR="$HOME/.claude/temp"
NAV_STATE="$STATE_DIR/nav_state.json"
CONV_CACHE="$STATE_DIR/codechats_cache.json"

# Ensure temp directory exists
mkdir -p "$STATE_DIR"

# Initialize navigation state
init_state() {
    echo '{"level": "main", "selected_project": "", "current_project": "'$(pwd)'"}' > "$NAV_STATE"
}

# Get current project path encoded for lookup
get_current_project_encoded() {
    echo "$(pwd)" | sed 's|/|-|g' | sed 's|^-||'
}

# Decode project path for display
decode_project_path() {
    echo "$1" | sed 's|-|/|g'
}

# Get conversation metadata
get_conversation_metadata() {
    local session_file="$1"
    
    # Basic file validation
    if [ ! -f "$session_file" ] || [ ! -s "$session_file" ]; then
        return 1
    fi
    
    local session_id=$(basename "$session_file" .jsonl)
    local project_path=$(echo "$session_file" | sed 's|.*/projects/||' | sed 's|/[^/]*\.jsonl||')
    
    # Extract metadata with better error handling
    local first_timestamp=$(head -1 "$session_file" 2>/dev/null | jq -r '.timestamp // "null"' 2>/dev/null)
    local last_timestamp=$(tail -1 "$session_file" 2>/dev/null | jq -r '.timestamp // "null"' 2>/dev/null)
    local message_count=$(wc -l < "$session_file" 2>/dev/null || echo "0")
    
    # Get first user message with better extraction
    local first_message=$(cat "$session_file" 2>/dev/null | jq -r 'select(.type == "user") | .message.content // ""' 2>/dev/null | head -1 | head -c 80 | tr -d '\000-\037' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//' | sed 's/["\]/\\&/g')
    
    # Fallback if no user message found
    if [ -z "$first_message" ] || [ "$first_message" = "null" ]; then
        first_message="CodeChat without initial message"
    fi
    
    # Calculate duration with safety checks
    local duration_min=0
    if [ "$first_timestamp" != "null" ] && [ "$last_timestamp" != "null" ] && [ -n "$first_timestamp" ] && [ -n "$last_timestamp" ]; then
        local start_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S" "${first_timestamp%.*}" "+%s" 2>/dev/null || echo "0")
        local end_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S" "${last_timestamp%.*}" "+%s" 2>/dev/null || echo "0")
        if [ "$start_epoch" != "0" ] && [ "$end_epoch" != "0" ] && [ "$end_epoch" -gt "$start_epoch" ]; then
            duration_min=$(( (end_epoch - start_epoch) / 60 ))
        fi
    fi
    
    # Extract tools used count
    local tools_used=$(grep -o '"name":"[^"]*"' "$session_file" 2>/dev/null | grep -c '"name"' || echo "0")
    
    # Auto-tag based on content
    local tags=""
    if grep -qi "docagent\|embedding\|chunk\|architecture" "$session_file" 2>/dev/null; then
        tags="${tags},architecture"
    fi
    if grep -qi "config\|setup\|claude\|configuration" "$session_file" 2>/dev/null; then
        tags="${tags},configuration"
    fi
    if grep -qi "test\|debug\|error\|failure" "$session_file" 2>/dev/null; then
        tags="${tags},debugging"
    fi
    if grep -qi "chats\|conversation\|history\|recuperador" "$session_file" 2>/dev/null; then
        tags="${tags},chat-system"
    fi
    
    # Clean leading comma
    tags=$(echo "$tags" | sed 's/^,//')
    
    # Determine recency
    local recency="old"
    if [ "$first_timestamp" != "null" ] && [ -n "$first_timestamp" ]; then
        local today=$(date +%Y-%m-%d)
        local conv_date=$(echo "$first_timestamp" | cut -d'T' -f1)
        if [ "$conv_date" = "$today" ]; then
            recency="today"
        elif [ $(( $(date +%s) - $(date -j -f "%Y-%m-%d" "$conv_date" "+%s" 2>/dev/null || echo "0") )) -lt 604800 ]; then
            recency="week"
        fi
    fi
    
    # Ensure we have valid data before outputting
    if [ -n "$session_id" ] && [ -n "$project_path" ]; then
        echo "${session_id}|${project_path}|${first_timestamp}|${duration_min}|${message_count}|${tools_used}|${first_message}|${tags}|${recency}"
    fi
}

# Update cache using Python script
update_cache() {
    echo "🔄 Updating CodeChats cache..." >&2
    python3 "$STATE_DIR/codechats_cache.py" >&2
}

# Show main menu
show_main_menu() {
    clear
    echo -e "${BOLD}${CYAN}💬 CODECHATS MANAGER${NC}"
    echo "════════════════════════════════════════════════════════════"
    echo
    
    local current_project=$(pwd)
    local current_encoded=$(get_current_project_encoded)
    
    echo -e "${PURPLE}📍 Current location:${NC} $current_project"
    echo
    
    # Count conversations in current project
    local current_count=$(jq --arg proj "$current_encoded" '[.[] | select(.project_path == $proj)] | length' "$CONV_CACHE" 2>/dev/null || echo "0")
    local total_projects=$(jq '[.[] | .project_path] | unique | length' "$CONV_CACHE" 2>/dev/null || echo "0")
    local total_conversations=$(jq 'length' "$CONV_CACHE" 2>/dev/null || echo "0")
    
    echo "Choose an option:"
    echo -e "[${GREEN}1${NC}] ${TARGET} Current project CodeChats (${current_count} found)"
    echo -e "[${GREEN}2${NC}] ${FOLDER} Explore other projects (${total_projects} projects available)"
    echo -e "[${GREEN}3${NC}] ${GLOBE} View all CodeChats (${total_conversations} total)"
    echo -e "[${GREEN}4${NC}] ${SEARCH} Search by specific term"
    echo -e "[${RED}5${NC}] ❌ Exit"
    echo
    echo -n "Your choice: "
}

# Open a specific conversation
open_conversation() {
    local session_id="$1"
    local project_encoded="$2"
    
    clear
    echo -e "${BOLD}${CYAN}📖 OPENING CODECHAT: ${session_id}${NC}"
    echo "════════════════════════════════════════════════════════════"
    echo
    
    # Find the session file
    local session_file=""
    if [ -n "$project_encoded" ]; then
        local project_decoded=$(decode_project_path "$project_encoded")
        session_file=$(find ~/.claude/projects -path "*${project_encoded}*/${session_id}.jsonl" | head -1)
    else
        session_file=$(find ~/.claude/projects -name "${session_id}.jsonl" | head -1)
    fi
    
    if [ ! -f "$session_file" ]; then
        echo "❌ CodeChat file not found: $session_id"
        echo
        echo -e "[${GREEN}Enter${NC}] Go back"
        read
        return
    fi
    
    echo -e "${PURPLE}📁 File:${NC} $session_file"
    echo -e "${PURPLE}📊 Statistics:${NC}"
    
    # Show conversation stats
    local message_count=$(wc -l < "$session_file")
    local first_timestamp=$(head -1 "$session_file" | jq -r '.timestamp' 2>/dev/null)
    local last_timestamp=$(tail -1 "$session_file" | jq -r '.timestamp' 2>/dev/null)
    
    echo -e "   💬 Total messages: ${message_count}"
    if [ "$first_timestamp" != "null" ] && [ "$last_timestamp" != "null" ]; then
        echo -e "   🕐 Started: $(echo $first_timestamp | cut -c1-19 | tr 'T' ' ')"
        echo -e "   🕐 Ended: $(echo $last_timestamp | cut -c1-19 | tr 'T' ' ')"
        
        local start_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S" "${first_timestamp%.*}" "+%s" 2>/dev/null || echo "0")
        local end_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S" "${last_timestamp%.*}" "+%s" 2>/dev/null || echo "0")
        local duration_min=$(( (end_epoch - start_epoch) / 60 ))
        echo -e "   ⏱️  Duration: ${duration_min} minutes"
    fi
    
    echo
    echo "Choose an action:"
    echo -e "[${GREEN}1${NC}] 👀 View last 10 messages"
    echo -e "[${GREEN}2${NC}] 📄 View complete conversation"
    echo -e "[${GREEN}3${NC}] 🔍 Search term in conversation"
    echo -e "[${GREEN}4${NC}] 📋 Copy file path"
    echo -e "[${GREEN}5${NC}] 🔄 Continue this conversation"
    echo -e "[${GREEN}B${NC}] ⬅️  Go back"
    echo
    echo -n "Your choice: "
    
    read -r action
    case "$action" in
        1)
            show_recent_messages "$session_file"
            ;;
        2)
            show_full_conversation "$session_file"
            ;;
        3)
            search_in_conversation "$session_file"
            ;;
        4)
            echo "$session_file" | pbcopy
            echo "✅ Path copied to clipboard!"
            sleep 2
            ;;
        5)
            continue_conversation "$session_id"
            ;;
        [bB])
            return
            ;;
        *)
            echo "❌ Invalid option. Press Enter to continue..."
            read
            open_conversation "$session_id" "$project_encoded"
            ;;
    esac
}

# Show recent messages from conversation
show_recent_messages() {
    local session_file="$1"
    
    clear
    echo -e "${BOLD}${CYAN}📖 LAST 10 MESSAGES${NC}"
    echo "════════════════════════════════════════════════════════════"
    echo
    
    # Extract and format recent messages
    tail -10 "$session_file" | while IFS= read -r line; do
        local timestamp=$(echo "$line" | jq -r '.timestamp' 2>/dev/null)
        local type=$(echo "$line" | jq -r '.type' 2>/dev/null)
        local content=""
        
        if [ "$type" = "user" ]; then
            content=$(echo "$line" | jq -r '.message.content' 2>/dev/null | head -c 200)
            echo -e "${GREEN}👤 USER ${NC}($(echo $timestamp | cut -c12-19))"
            echo "   $content"
        elif [ "$type" = "assistant" ]; then
            content=$(echo "$line" | jq -r '.message.content[0].text // .message.content' 2>/dev/null | head -c 200)
            echo -e "${BLUE}🤖 ASSISTANT ${NC}($(echo $timestamp | cut -c12-19))"
            echo "   $content"
        fi
        echo
    done
    
    echo -e "[${GREEN}Enter${NC}] Go back"
    read
}

# Show full conversation
show_full_conversation() {
    local session_file="$1"
    
    clear
    echo -e "${BOLD}${CYAN}📖 COMPLETE CONVERSATION${NC}"
    echo "════════════════════════════════════════════════════════════"
    echo
    echo "💡 Use 'q' to exit the viewer"
    echo
    sleep 2
    
    # Use less for better navigation
    cat "$session_file" | jq -r '
        if .type == "user" then
            "👤 USER (" + (.timestamp | .[11:19]) + ")\n   " + (.message.content // "")
        elif .type == "assistant" then
            "🤖 ASSISTANT (" + (.timestamp | .[11:19]) + ")\n   " + (.message.content[0].text // .message.content // "")
        else
            empty
        end
    ' | less
}

# Search in conversation
search_in_conversation() {
    local session_file="$1"
    
    clear
    echo -e "${BOLD}${CYAN}🔍 SEARCH IN CONVERSATION${NC}"
    echo "════════════════════════════════════════════════════════════"
    echo
    echo -n "Enter search term: "
    read -r search_term
    
    if [ -z "$search_term" ]; then
        echo "❌ Empty search term."
        sleep 2
        return
    fi
    
    echo
    echo -e "${PURPLE}🔍 Searching for: '${search_term}'${NC}"
    echo "════════════════════════════════════════════════════════════"
    
    # Search in the file
    local results=$(grep -i "$search_term" "$session_file" | head -10)
    
    if [ -z "$results" ]; then
        echo "❌ No results found."
    else
        echo "$results" | while IFS= read -r line; do
            local timestamp=$(echo "$line" | jq -r '.timestamp' 2>/dev/null)
            local type=$(echo "$line" | jq -r '.type' 2>/dev/null)
            local content=""
            
            if [ "$type" = "user" ]; then
                content=$(echo "$line" | jq -r '.message.content' 2>/dev/null)
                echo -e "${GREEN}👤 USER ${NC}($(echo $timestamp | cut -c1-19 | tr 'T' ' '))"
            elif [ "$type" = "assistant" ]; then
                content=$(echo "$line" | jq -r '.message.content[0].text // .message.content' 2>/dev/null)
                echo -e "${BLUE}🤖 ASSISTANT ${NC}($(echo $timestamp | cut -c1-19 | tr 'T' ' '))"
            fi
            
            # Highlight search term
            echo "   $(echo "$content" | grep -i --color=always "$search_term" | head -c 300)"
            echo
        done
    fi
    
    echo
    echo -e "[${GREEN}Enter${NC}] Go back"
    read
}

# Continue conversation
continue_conversation() {
    local session_id="$1"
    
    clear
    echo -e "${BOLD}${CYAN}🔄 CONTINUE CONVERSATION${NC}"
    echo "════════════════════════════════════════════════════════════"
    echo
    echo -e "${YELLOW}⚠️  This function requires Claude Code's 'continueconversation' command${NC}"
    echo
    echo -e "${PURPLE}To continue this conversation:${NC}"
    echo "1. Close this script"
    echo "2. Run in terminal: continueconversation $session_id"
    echo
    echo -e "${CYAN}Command to copy:${NC}"
    echo "continueconversation $session_id"
    echo
    echo -n "Press Enter to copy command and exit..."
    read
    
    echo "continueconversation $session_id" | pbcopy
    echo "✅ Command copied! Run it in the terminal."
    exit 0
}

# Show project conversations
show_project_conversations() {
    local project_encoded="$1"
    local project_decoded=$(decode_project_path "$project_encoded")
    
    clear
    echo -e "${BOLD}${CYAN}${TARGET} PROJECT: ${project_decoded}${NC}"
    echo "════════════════════════════════════════════════════════════"
    echo
    
    # Get conversations for this project, sorted by recency
    local conversations=$(jq --arg proj "$project_encoded" '[.[] | select(.project_path == $proj)] | sort_by(.timestamp) | reverse' "$CONV_CACHE" 2>/dev/null)
    local count=$(echo "$conversations" | jq 'length' 2>/dev/null)
    
    if [ "$count" = "0" ]; then
        echo "❌ No CodeChats found for this project."
        echo
        echo -e "[${GREEN}M${NC}] Main menu"
        echo -n "Your choice: "
        return
    fi
    
    echo -e "${PURPLE}📊 ${count} CodeChats found (sorted by recent):${NC}"
    echo
    
    # Store conversation data for selection
    local conv_data=""
    
    # Show conversations with smart formatting
    local index=0
    while IFS='|' read -r session_id timestamp duration messages first_msg tags recency; do
        index=$((index + 1))
        local letter=$(printf "\\$(printf '%03o' $((64 + index)))")
        
        # Store data for later use
        conv_data="${conv_data}${letter}:${session_id}|"
        
        # Format timestamp
        local display_time="Old"
        if [ "$timestamp" != "null" ]; then
            if [ "$recency" = "today" ]; then
                display_time="${FIRE} [Today $(echo $timestamp | cut -c12-16)]"
            elif [ "$recency" = "week" ]; then
                display_time="${LIGHTNING} [$(echo $timestamp | cut -c6-10)]"
            else
                display_time="${BOOK} [$(echo $timestamp | cut -c1-10)]"
            fi
        fi
        
        # Format title based on content
        local title="General CodeChat"
        if echo "$tags" | grep -q "architecture"; then
            title="Architecture Analysis"
        elif echo "$tags" | grep -q "configuration"; then
            title="System Configuration"
        elif echo "$tags" | grep -q "debugging"; then
            title="Debug/Testing"
        fi
        
        echo -e "[${GREEN}$letter${NC}] $display_time     ${BOLD}$title${NC}     (${duration}min, ${messages} msgs)"
        echo -e "    ${PURPLE}💬${NC} \"$first_msg...\""
        if [ -n "$tags" ]; then
            echo -e "    ${CYAN}🏷️  Tags:${NC} $(echo $tags | sed 's/,/, /g' | sed 's/^,//')"
        fi
        echo
        
        if [ $index -ge 10 ]; then
            break
        fi
    done < <(echo "$conversations" | jq -r '.[] | "\(.session_id)|\(.timestamp)|\(.duration_min)|\(.message_count)|\(.first_message)|\(.tags)|\(.recency)"')
    
    # Store conversation data in state for selection
    echo "$conv_data" > "$STATE_DIR/current_conversations.tmp"
    
    echo "Choose: [A-$(printf "\\$(printf '%03o' $((64 + index)))")] to open | [M] Main menu | [P] Other projects"
    echo -n "Your choice: "
}

# Show search interface
show_search_interface() {
    clear
    echo -e "${BOLD}${CYAN}${SEARCH} SEARCH CODECHATS${NC}"
    echo "════════════════════════════════════════════════════════════"
    echo
    echo -n "Enter search term: "
    read -r search_term
    
    if [ -z "$search_term" ]; then
        echo "❌ Empty search term."
        sleep 2
        return
    fi
    
    echo
    echo -e "${PURPLE}🔍 Searching for: '${search_term}'${NC}"
    echo "════════════════════════════════════════════════════════════"
    echo
    
    # Search across all conversations
    local results=()
    local result_count=0
    
    find ~/.claude/projects -name "*.jsonl" | while read session_file; do
        if grep -qi "$search_term" "$session_file" 2>/dev/null; then
            local session_id=$(basename "$session_file" .jsonl)
            local project_path=$(echo "$session_file" | sed 's|.*/projects/||' | sed 's|/[^/]*\.jsonl||')
            local project_decoded=$(decode_project_path "$project_path")
            
            # Get metadata
            local metadata=$(get_conversation_metadata "$session_file")
            if [ -n "$metadata" ]; then
                IFS='|' read -r sid ppath timestamp duration messages tools first_msg tags recency <<< "$metadata"
                
                result_count=$((result_count + 1))
                local letter=$(printf "\\$(printf '%03o' $((64 + result_count)))")
                
                # Format timestamp
                local display_time="Old"
                if [ "$timestamp" != "null" ]; then
                    if [ "$recency" = "today" ]; then
                        display_time="${FIRE} [Today $(echo $timestamp | cut -c12-16)]"
                    elif [ "$recency" = "week" ]; then
                        display_time="${LIGHTNING} [$(echo $timestamp | cut -c6-10)]"
                    else
                        display_time="${BOOK} [$(echo $timestamp | cut -c1-10)]"
                    fi
                fi
                
                # Format title based on content
                local title="General CodeChat"
                if echo "$tags" | grep -q "architecture"; then
                    title="Architecture Analysis"
                elif echo "$tags" | grep -q "configuration"; then
                    title="System Configuration"
                elif echo "$tags" | grep -q "debugging"; then
                    title="Debug/Testing"
                fi
                
                echo -e "[${GREEN}$letter${NC}] $display_time     ${BOLD}$title${NC}     (${duration}min, ${messages} msgs)"
                echo -e "    ${PURPLE}📁 Project:${NC} $project_decoded"
                echo -e "    ${PURPLE}💬${NC} \"$first_msg...\""
                
                # Show search context
                local context=$(grep -i "$search_term" "$session_file" | head -1 | jq -r '
                    if .type == "user" then
                        (.message.content // "")
                    elif .type == "assistant" then
                        (.message.content[0].text // .message.content // "")
                    else
                        ""
                    end
                ' 2>/dev/null | head -c 150)
                
                if [ -n "$context" ]; then
                    echo -e "    ${YELLOW}🔍 Context:${NC} \"$(echo "$context" | grep -i --color=always "$search_term")...\""
                fi
                
                if [ -n "$tags" ]; then
                    echo -e "    ${CYAN}🏷️  Tags:${NC} $(echo $tags | sed 's/,/, /g' | sed 's/^,//')"
                fi
                echo
                
                # Store for selection
                echo "${letter}:${session_id}:${project_path}" >> "$STATE_DIR/search_results.tmp"
                
                if [ $result_count -ge 15 ]; then
                    echo -e "${YELLOW}... (limited to 15 results)${NC}"
                    echo
                    break
                fi
            fi
        fi
    done
    
    if [ $result_count -eq 0 ]; then
        echo "❌ No results found for '$search_term'"
        echo
        echo -e "[${GREEN}Enter${NC}] Back to main menu"
        read
        return
    fi
    
    echo "Choose: [A-$(printf "\\$(printf '%03o' $((64 + result_count)))")] to open | [M] Main menu | [N] New search"
    echo -n "Your choice: "
    
    read -r choice
    case "$choice" in
        [mM])
            rm -f "$STATE_DIR/search_results.tmp"
            ;;
        [nN])
            rm -f "$STATE_DIR/search_results.tmp"
            show_search_interface
            ;;
        [a-zA-Z])
            if [ -f "$STATE_DIR/search_results.tmp" ]; then
                local search_result=$(grep "^${choice}:" "$STATE_DIR/search_results.tmp" | head -1)
                if [ -n "$search_result" ]; then
                    local session_id=$(echo "$search_result" | cut -d':' -f2)
                    local project_path=$(echo "$search_result" | cut -d':' -f3)
                    open_conversation "$session_id" "$project_path"
                else
                    echo "❌ Result not found for option '$choice'"
                    sleep 2
                    show_search_interface
                fi
                rm -f "$STATE_DIR/search_results.tmp"
            else
                echo "❌ Search data not found."
                sleep 2
            fi
            ;;
        *)
            echo "❌ Invalid option. Press Enter to continue..."
            read
            show_search_interface
            ;;
    esac
}

# Show project selector
show_project_selector() {
    clear
    echo -e "${BOLD}${CYAN}${FOLDER} PROJECT SELECTOR${NC}"
    echo "════════════════════════════════════════════════════════════"
    echo
    
    # Get all projects with conversations
    local projects=$(jq -r '[.[] | .project_path] | unique | .[]' "$CONV_CACHE" 2>/dev/null)
    local project_count=0
    local project_data=""
    
    echo -e "${PURPLE}📊 Projects with CodeChats:${NC}"
    echo
    
    while IFS= read -r project_encoded; do
        if [ -n "$project_encoded" ]; then
            project_count=$((project_count + 1))
            local letter=$(printf "\\$(printf '%03o' $((64 + project_count)))")
            local project_decoded=$(decode_project_path "$project_encoded")
            
            # Count conversations in this project
            local conv_count=$(jq --arg proj "$project_encoded" '[.[] | select(.project_path == $proj)] | length' "$CONV_CACHE" 2>/dev/null || echo "0")
            
            # Get recent activity
            local recent_timestamp=$(jq --arg proj "$project_encoded" '[.[] | select(.project_path == $proj)] | sort_by(.timestamp) | reverse | .[0].timestamp' "$CONV_CACHE" 2>/dev/null)
            local recent_display="No activity"
            
            if [ "$recent_timestamp" != "null" ] && [ -n "$recent_timestamp" ]; then
                local recent_date=$(echo "$recent_timestamp" | cut -c1-10)
                local today=$(date +%Y-%m-%d)
                
                if [ "$recent_date" = "$today" ]; then
                    recent_display="${FIRE} Today $(echo $recent_timestamp | cut -c12-16)"
                elif [ $(( $(date +%s) - $(date -j -f "%Y-%m-%d" "$recent_date" "+%s" 2>/dev/null || echo "0") )) -lt 604800 ]; then
                    recent_display="${LIGHTNING} This week"
                else
                    recent_display="${BOOK} $recent_date"
                fi
            fi
            
            # Determine project type/icon
            local project_icon="📁"
            local project_name=$(basename "$project_decoded")
            
            if echo "$project_name" | grep -qi "server\|infrastructure"; then
                project_icon="🌐"
            elif echo "$project_name" | grep -qi "ai\|artificial"; then
                project_icon="🤖"
            elif echo "$project_name" | grep -qi "viveris\|restaurant\|food"; then
                project_icon="🌱"
            elif echo "$project_name" | grep -qi "selall\|ecommerce\|shop"; then
                project_icon="📦"
            elif echo "$project_name" | grep -qi "python\|code"; then
                project_icon="🐍"
            elif echo "$project_name" | grep -qi "crypto\|finance"; then
                project_icon="📈"
            fi
            
            echo -e "[${GREEN}$letter${NC}] $project_icon ${BOLD}$(basename "$project_decoded")${NC}     ($conv_count CodeChats)"
            echo -e "    ${PURPLE}📍${NC} $project_decoded"
            echo -e "    ${CYAN}🕐 Last activity:${NC} $recent_display"
            echo
            
            # Store project data for selection
            project_data="${project_data}${letter}:${project_encoded}|"
        fi
    done <<< "$projects"
    
    if [ $project_count -eq 0 ]; then
        echo "❌ No projects with CodeChats found."
        echo
        echo -e "[${GREEN}M${NC}] Main menu"
        echo -n "Your choice: "
        return
    fi
    
    # Store project data for selection
    echo "$project_data" > "$STATE_DIR/current_projects.tmp"
    
    echo "Choose: [A-$(printf "\\$(printf '%03o' $((64 + project_count)))")] to explore | [M] Main menu | [C] Current project"
    echo -n "Your choice: "
    
    read -r choice
    case "$choice" in
        [mM])
            rm -f "$STATE_DIR/current_projects.tmp"
            ;;
        [cC])
            rm -f "$STATE_DIR/current_projects.tmp"
            local current_encoded=$(get_current_project_encoded)
            echo "{\"level\": \"project\", \"selected_project\": \"$current_encoded\"}" > "$NAV_STATE"
            ;;
        [a-zA-Z])
            if [ -f "$STATE_DIR/current_projects.tmp" ]; then
                local proj_data=$(cat "$STATE_DIR/current_projects.tmp")
                local selected_project=$(echo "$proj_data" | grep -o "${choice}:[^|]*" | cut -d':' -f2)
                
                if [ -n "$selected_project" ]; then
                    echo "{\"level\": \"project\", \"selected_project\": \"$selected_project\"}" > "$NAV_STATE"
                else
                    echo "❌ Project not found for option '$choice'"
                    sleep 2
                    show_project_selector
                fi
                rm -f "$STATE_DIR/current_projects.tmp"
            else
                echo "❌ Project data not found."
                sleep 2
            fi
            ;;
        *)
            echo "❌ Invalid option. Press Enter to continue..."
            read
            show_project_selector
            ;;
    esac
}

# Show all conversations across projects
show_all_conversations() {
    clear
    echo -e "${BOLD}${CYAN}${GLOBE} ALL CODECHATS${NC}"
    echo "════════════════════════════════════════════════════════════"
    echo
    
    # Get all conversations sorted by recency
    local conversations=$(jq '. | sort_by(.timestamp) | reverse' "$CONV_CACHE" 2>/dev/null)
    local total_count=$(echo "$conversations" | jq 'length' 2>/dev/null)
    
    if [ "$total_count" = "0" ]; then
        echo "❌ No CodeChats found."
        echo
        echo -e "[${GREEN}M${NC}] Main menu"
        echo -n "Your choice: "
        return
    fi
    
    echo -e "${PURPLE}📊 Total: ${total_count} CodeChats (showing last 20):${NC}"
    echo
    
    # Group by recency for better organization
    echo -e "${BOLD}${FIRE} TODAY${NC}"
    local today_count=0
    local week_count=0
    local old_count=0
    local all_data=""
    local display_count=0
    
    # Today's conversations
    while IFS='|' read -r session_id project_path timestamp duration messages tools first_msg tags recency; do
        if [ "$recency" = "today" ] && [ $display_count -lt 20 ]; then
            today_count=$((today_count + 1))
            display_count=$((display_count + 1))
            local letter=$(printf "\\$(printf '%03o' $((64 + display_count)))")
            
            local project_decoded=$(decode_project_path "$project_path")
            local project_name=$(basename "$project_decoded")
            
            # Format title
            local title="General CodeChat"
            if echo "$tags" | grep -q "architecture"; then
                title="Architecture Analysis"
            elif echo "$tags" | grep -q "configuration"; then
                title="System Configuration"
            elif echo "$tags" | grep -q "debugging"; then
                title="Debug/Testing"
            fi
            
            echo -e "  [${GREEN}$letter${NC}] ${FIRE} $(echo $timestamp | cut -c12-16)     ${BOLD}$title${NC}     (${duration}min, ${messages} msgs)"
            echo -e "      ${PURPLE}📁${NC} $project_name"
            echo -e "      ${PURPLE}💬${NC} \"$first_msg...\""
            echo
            
            all_data="${all_data}${letter}:${session_id}:${project_path}|"
        fi
    done < <(echo "$conversations" | jq -r '.[] | "\(.session_id)|\(.project_path)|\(.timestamp)|\(.duration_min)|\(.message_count)|\(.tools_count)|\(.first_message)|\(.tags)|\(.recency)"')
    
    if [ $today_count -eq 0 ]; then
        echo "  (No CodeChats today)"
        echo
    fi
    
    # This week's conversations
    if [ $display_count -lt 20 ]; then
        echo -e "${BOLD}${LIGHTNING} THIS WEEK${NC}"
        while IFS='|' read -r session_id project_path timestamp duration messages tools first_msg tags recency; do
            if [ "$recency" = "week" ] && [ $display_count -lt 20 ]; then
                week_count=$((week_count + 1))
                display_count=$((display_count + 1))
                local letter=$(printf "\\$(printf '%03o' $((64 + display_count)))")
                
                local project_decoded=$(decode_project_path "$project_path")
                local project_name=$(basename "$project_decoded")
                
                local title="General CodeChat"
                if echo "$tags" | grep -q "architecture"; then
                    title="Architecture Analysis"
                elif echo "$tags" | grep -q "configuration"; then
                    title="System Configuration"
                elif echo "$tags" | grep -q "debugging"; then
                    title="Debug/Testing"
                fi
                
                echo -e "  [${GREEN}$letter${NC}] ${LIGHTNING} $(echo $timestamp | cut -c6-10)     ${BOLD}$title${NC}     (${duration}min, ${messages} msgs)"
                echo -e "      ${PURPLE}📁${NC} $project_name"
                echo -e "      ${PURPLE}💬${NC} \"$first_msg...\""
                echo
                
                all_data="${all_data}${letter}:${session_id}:${project_path}|"
            fi
        done < <(echo "$conversations" | jq -r '.[] | "\(.session_id)|\(.project_path)|\(.timestamp)|\(.duration_min)|\(.message_count)|\(.tools_count)|\(.first_message)|\(.tags)|\(.recency)"')
        
        if [ $week_count -eq 0 ]; then
            echo "  (No CodeChats this week)"
            echo
        fi
    fi
    
    # Older conversations
    if [ $display_count -lt 20 ]; then
        echo -e "${BOLD}${BOOK} OLDER${NC}"
        while IFS='|' read -r session_id project_path timestamp duration messages tools first_msg tags recency; do
            if [ "$recency" = "old" ] && [ $display_count -lt 20 ]; then
                old_count=$((old_count + 1))
                display_count=$((display_count + 1))
                local letter=$(printf "\\$(printf '%03o' $((64 + display_count)))")
                
                local project_decoded=$(decode_project_path "$project_path")
                local project_name=$(basename "$project_decoded")
                
                local title="General CodeChat"
                if echo "$tags" | grep -q "architecture"; then
                    title="Architecture Analysis"
                elif echo "$tags" | grep -q "configuration"; then
                    title="System Configuration"
                elif echo "$tags" | grep -q "debugging"; then
                    title="Debug/Testing"
                fi
                
                echo -e "  [${GREEN}$letter${NC}] ${BOOK} $(echo $timestamp | cut -c1-10)     ${BOLD}$title${NC}     (${duration}min, ${messages} msgs)"
                echo -e "      ${PURPLE}📁${NC} $project_name"
                echo -e "      ${PURPLE}💬${NC} \"$first_msg...\""
                echo
                
                all_data="${all_data}${letter}:${session_id}:${project_path}|"
            fi
        done < <(echo "$conversations" | jq -r '.[] | "\(.session_id)|\(.project_path)|\(.timestamp)|\(.duration_min)|\(.message_count)|\(.tools_count)|\(.first_message)|\(.tags)|\(.recency)"')
        
        if [ $old_count -eq 0 ]; then
            echo "  (No older CodeChats)"
            echo
        fi
    fi
    
    # Store all conversation data for selection
    echo "$all_data" > "$STATE_DIR/all_conversations.tmp"
    
    echo "Choose: [A-$(printf "\\$(printf '%03o' $((64 + display_count)))")] to open | [M] Main menu | [S] Search"
    echo -n "Your choice: "
    
    read -r choice
    case "$choice" in
        [mM])
            rm -f "$STATE_DIR/all_conversations.tmp"
            ;;
        [sS])
            rm -f "$STATE_DIR/all_conversations.tmp"
            show_search_interface
            ;;
        [a-zA-Z])
            if [ -f "$STATE_DIR/all_conversations.tmp" ]; then
                local all_conv_data=$(cat "$STATE_DIR/all_conversations.tmp")
                local conv_result=$(echo "$all_conv_data" | grep -o "${choice}:[^|]*")
                
                if [ -n "$conv_result" ]; then
                    local session_id=$(echo "$conv_result" | cut -d':' -f2)
                    local project_path=$(echo "$conv_result" | cut -d':' -f3)
                    open_conversation "$session_id" "$project_path"
                else
                    echo "❌ Conversation not found for option '$choice'"
                    sleep 2
                    show_all_conversations
                fi
                rm -f "$STATE_DIR/all_conversations.tmp"
            else
                echo "❌ Conversation data not found."
                sleep 2
            fi
            ;;
        *)
            echo "❌ Invalid option. Press Enter to continue..."
            read
            show_all_conversations
            ;;
    esac
}

# Main execution
main() {
    # Initialize state if not exists
    if [ ! -f "$NAV_STATE" ]; then
        init_state
    fi
    
    # Cache conversations if cache doesn't exist or is old
    if [ ! -f "$CONV_CACHE" ] || [ $(find "$CONV_CACHE" -mmin +60 2>/dev/null | wc -l) -gt 0 ]; then
        echo "🔄 Updating CodeChats cache..." >&2
        python3 "$STATE_DIR/codechats-cache.py" >&2
    fi
    
    while true; do
        local current_level=$(jq -r '.level' "$NAV_STATE" 2>/dev/null || echo "main")
        
        case "$current_level" in
            "main")
                show_main_menu
                read -r choice
                case "$choice" in
                    1)
                        local current_encoded=$(get_current_project_encoded)
                        echo '{"level": "project", "selected_project": "'$current_encoded'"}' > "$NAV_STATE"
                        ;;
                    2)
                        show_project_selector
                        ;;
                    3)
                        show_all_conversations
                        ;;
                    4)
                        show_search_interface
                        ;;
                    5|q|Q)
                        echo "👋 Goodbye!"
                        exit 0
                        ;;
                    *)
                        echo "❌ Invalid option. Press Enter to continue..."
                        read
                        ;;
                esac
                ;;
            "project")
                local selected_project=$(jq -r '.selected_project' "$NAV_STATE" 2>/dev/null)
                show_project_conversations "$selected_project"
                read -r choice
                case "$choice" in
                    [mM])
                        echo '{"level": "main"}' > "$NAV_STATE"
                        ;;
                    [pP])
                        show_project_selector
                        ;;
                    [a-zA-Z])
                        # Handle chat selection
                        if [ -f "$STATE_DIR/current_conversations.tmp" ]; then
                            local conv_data=$(cat "$STATE_DIR/current_conversations.tmp")
                            local session_id=$(echo "$conv_data" | grep -o "${choice}:[^|]*" | cut -d':' -f2)
                            
                            if [ -n "$session_id" ]; then
                                open_conversation "$session_id" "$selected_project"
                            else
                                echo "❌ Conversation not found for option '$choice'"
                                sleep 2
                            fi
                        else
                            echo "❌ Conversation data not found."
                            sleep 2
                        fi
                        ;;
                    *)
                        echo "❌ Invalid option. Press Enter to continue..."
                        read
                        ;;
                esac
                ;;
            *)
                # Reset to main menu for any unknown state
                ;;
        esac
    done
}

# Run main function
main "$@"

# CodeChats Manager v1.0.0 - Interactive conversation history manager for Claude Code
# by MAUGUS ✌️
# Repository: https://github.com/MAUGUS2/codechats-manager