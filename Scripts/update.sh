#!/bin/bash

SOURCE_DIR="./Sources/ssh/src"
DEST_DIR="./Sources/SwiftLibSSH"

mkdir -p "$DEST_DIR"

find "$SOURCE_DIR" -type f -exec cp {} "$DEST_DIR" \;


replace_content() {
    local search="$1"
    local replace="$2"
    local target_dir="$3"
    
    find "$target_dir" -type f -name "*.swift" -exec sed -i '' "s/$search/$replace/g" {} \;
}

# replace import CSSH to import SwiftCSSH
replace_content "import CSSH" "import SwiftCSSH" "$DEST_DIR"
replace_content "extension SSH" "extension SwiftLibSSH" "$DEST_DIR"
replace_content "public class SSH" "public class SwiftLibSSH" "$DEST_DIR"
replace_content "ssh: SSH" "ssh: SwiftLibSSH" "$DEST_DIR"
replace_content "SSH.getSSH" "SwiftLibSSH.getSSH" "$DEST_DIR"
replace_content "-> SSH" "-> SwiftLibSSH" "$DEST_DIR"
replace_content "SSH.self" "SwiftLibSSH.self" "$DEST_DIR"


process_openssl() {
    local file="$1"
    local tmp_file=$(mktemp)
    # 第一阶段：保留OPEN_SSL块，去除非OPEN_SSL代码
    awk '
        BEGIN { keep = 1; in_open_ssl = 0 }
        /#if OPEN_SSL/ { in_open_ssl = 1; keep = 1; next }
        /#else/ { if (in_open_ssl) keep = 0; next }
        /#endif/ { if (in_open_ssl) { in_open_ssl = 0; keep = 1; next } }
        { if (keep) print }
    ' "$file" > "$tmp_file"

    mv "$tmp_file" "$file"

    # 第二阶段：精确删除OPEN_SSL的条件编译符号，只移除成对的 #if OPEN_SSL 和 #endif
    awk '
        BEGIN { open_ssl_depth = 0 }
        
        # 进入 #if OPEN_SSL 块时增加计数
        /#if OPEN_SSL/ { open_ssl_depth++; next }

        # 退出 #if OPEN_SSL 块时减少计数
        /#endif/ { 
            if (open_ssl_depth > 0) { 
                open_ssl_depth--; 
                next 
            } 
        }

        # 打印不在 #if OPEN_SSL 计数器中的代码
        { print }
    ' "$file" > "$tmp_file"

    mv "$tmp_file" "$file"
}

# use openssl only
find "$DEST_DIR" -type f -name "*.swift" | while read -r file; do
    echo "[INFO] Processing $file..."
    process_openssl "$file" || echo "[ERROR] Failed to process $file"
done

# add "import SwiftCSSL" to Algorithm.swift, Crypto.swift, HMAC.swift, Key.swift, and Sha.swift
find "$DEST_DIR" -type f -name "Algorithm.swift" -exec sed -i '' '1s/^/import SwiftCSSL\n/' {} \;
find "$DEST_DIR" -type f -name "Crypto.swift" -exec sed -i '' '1s/^/import SwiftCSSL\n/' {} \;
find "$DEST_DIR" -type f -name "HMAC.swift" -exec sed -i '' '1s/^/import SwiftCSSL\n/' {} \;
find "$DEST_DIR" -type f -name "Key.swift" -exec sed -i '' '1s/^/import SwiftCSSL\n/' {} \;
find "$DEST_DIR" -type f -name "Sha.swift" -exec sed -i '' '1s/^/import SwiftCSSL\n/' {} \;