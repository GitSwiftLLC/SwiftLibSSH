#!/bin/bash

SOURCE_DIR="./Sources/ssh/src"
DEST_DIR="./Sources/SwiftLibSSH"

mkdir -p "$DEST_DIR"

find "$SOURCE_DIR" -type f -name "*.swift" -exec cp {} "$DEST_DIR" \;
find "./Sources/cssh/src" -type f -name "*.c" -exec cp {} "./Sources/clib" \;
find "./Sources/cssh/src" -type f -name "*.h" -exec cp {} "./Sources/clib/include" \;

replace_content() {
    local search="$1"
    local replace="$2"
    local target_dir="$3"
    
    find "$target_dir" -type f -name "*.swift" -exec sed -i '' "s/$search/$replace/g" {} \;
}
replace_file_content() {
    local file_path="$1"
    local search="$2"
    local replace="$3"
    
    if [[ ! -f "$file_path" ]]; then
        echo "Error: File not found at $file_path"
        return 1
    fi
    
    sed -i '' "s/$search/$replace/g" "$file_path"
    
    if [[ $? -eq 0 ]]; then
        echo "Replaced '$search' with '$replace' in $file_path"
    else
        echo "Error: Failed to replace content in $file_path"
        return 1
    fi
}
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

# replace some common content to all files
# replace_content "import CSSH" "import SwiftCSSH" "$DEST_DIR"
replace_content "extension SSH" "extension SwiftLibSSH" "$DEST_DIR"
replace_content "public class SSH" "public class SwiftLibSSH" "$DEST_DIR"
replace_content "ssh: SSH" "ssh: SwiftLibSSH" "$DEST_DIR"
replace_content "SSH.getSSH" "SwiftLibSSH.getSSH" "$DEST_DIR"
replace_content "-> SSH" "-> SwiftLibSSH" "$DEST_DIR"
replace_content "SSH.self" "SwiftLibSSH.self" "$DEST_DIR"

# use openssl only
find "$DEST_DIR" -type f -name "*.swift" | while read -r file; do
    echo "[INFO] Processing $file..."
    process_openssl "$file" || echo "[ERROR] Failed to process $file"
done
replace_content "import OpenSSL" "import SwiftCSSL" "$DEST_DIR"



# Add SwiftCSSH to some files
replace_file_content "$DEST_DIR/Auth.swift" "import CSSH" "import SwiftCSSH"
replace_file_content "$DEST_DIR/Call.swift" "import CSSH" "import SwiftCSSH"
replace_file_content "$DEST_DIR/Channel.swift" "import CSSH" "import SwiftCSSH"
replace_file_content "$DEST_DIR/Direct.swift" "import CSSH" "import SwiftCSSH"
replace_file_content "$DEST_DIR/File.swift" "import CSSH" "import SwiftCSSH"
replace_file_content "$DEST_DIR/Machine.swift" "import CSSH" "import SwiftCSSH"
replace_file_content "$DEST_DIR/Protocol.swift" "import CSSH" "import SwiftCSSH"
replace_file_content "$DEST_DIR/Session.swift" "import CSSH" "import SwiftCSSH"
replace_file_content "$DEST_DIR/SFTP.swift" "import CSSH" "import SwiftCSSH"
replace_file_content "$DEST_DIR/Shell.swift" "import CSSH" "import SwiftCSSH"
replace_file_content "$DEST_DIR/Socket.swift" "import CSSH" "import SwiftCSSH"
replace_file_content "$DEST_DIR/SSH.swift" "import CSSH" "import SwiftCSSH"
replace_file_content "$DEST_DIR/Stream.swift" "import CSSH" "import SwiftCSSH"
replace_file_content "$DEST_DIR/Types.swift" "import CSSH" "import SwiftCSSH"
replace_file_content "$DEST_DIR/String+.swift" "import CSSH" "import clib"
replace_file_content "$DEST_DIR/DNSProvider.swift" "import Network" "import Network\nimport Foundation"
replace_file_content "$DEST_DIR/DNS.swift" "import CSSH" "import clib"
replace_file_content "$DEST_DIR/Key.swift" "import CSSH" "import clib"

replace_file_content "$DEST_DIR/Session.swift" "SSH-2.0-SSH2.app" "SSH-2.0-SwiftServer.app"
replace_file_content "$DEST_DIR/Session.swift" "SSH-2.0-libssh2_SSH2.app" "SSH-2.0-SwiftServer.app"