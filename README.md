# scrtot
Source Code To Text

This Bash script exports all **text files** tracked by Git into a single `.txt` file, ignoring hidden files and binary files (as determined by MIME type). The resulting file name is automatically generated based on the **current directory name**—converted to lowercase and with spaces replaced by underscores.

## Key Features
1. **Checks Git Repository**: Aborts if the current directory is not under Git.
2. **Filters Files**:
   - Only processes files tracked by Git (`git ls-files`).
   - Skips hidden files/folders.
   - Skips non-text files (based on MIME type).

## Installation & Usage

### Option 1: Run via cURL (Primary & Quick)
Just run the following command in the terminal for your project:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/utsmannn/srctot/main/srctot.sh)"
```

The script will create a file named `<folder_name>.txt`, where `<folder_name>` is your current directory name in lowercase with spaces replaced by underscores.

### Option 2: Manual Download (Alternative)
1. **Clone or Download** this script (e.g., `export_code.sh`) into the root of your Git project.
2. **Make it executable**:
   
```bash
chmod +x export_code.sh
```
   
4. **Run**:
   
```bash
./export_code.sh
```



## How It Works

1. **Check Git**:
   
```bash
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
 echo "Error: This directory is not a Git repository. Script aborted."
 exit 1
fi
```
 
   This ensures you’re inside a valid Git repo.
   
2. **Gather Files**:
   - Uses `git ls-files` to list tracked files.
   - Skips any path starting with `.` (dot).
   - Checks MIME type (`file --mime-type`) to ensure it begins with `text/`.
3. **Output Structure**:
   For each file, appends this format:
   
```
=======
<filename>
<path/to/filename>
=======
(file contents)

=======
...
=======
```

## Example Output

If your folder name is `My Project`, the script produces `my_project.txt`, which might look like:

```
=======
MainActivity.kt
app/src/main/java/com/example/MainActivity.kt
=======
package com.example

fun main() {
    println("Hello World")
}

=======
SecondActivity.kt
app/src/main/java/com/example/SecondActivity.kt
=======
package com.example

class SecondActivity { ... }

=======
```

## Potential Use Cases

1. **Emergency Backup**  
Quickly save the entire source code as a single `.txt` file, which can be archived or shared without needing the entire folder structure.

2. **Audit or Quick Code Review**  
Provide a single file for easy scanning, searching, or offline review by teammates or auditors.

3. **Limited Bandwidth or Restricted Platforms**  
Some channels (chat, email, ticketing systems) may only allow one attachment or have trouble with multiple files. A single `.txt` simplifies sharing.

4. **Reference for Documentation**  
Attach a single `.txt` as an appendix in documents, making it easier to reference the entire codebase in one place.

5. **Automated Text Processing**  
Having all code in one file can simplify certain text-processing tasks, such as text-mining, keyword analysis, or creating a basic code index.

6. **Input to Large Language Models (LLMs)**  
Useful for **ChatGPT** or other AI tools when you need to analyze or review large portions of code in one shot, subject to token limits.

7. **RAG (Retrieval-Augmented Generation) Pipeline**  
Storing code in one `.txt` file simplifies chunking and indexing for retrieval-based AI workflows, so you can easily embed or search code as a single document.

8. **DevOps or CI/CD Integrations**  
Custom pipelines or scripts might require a single text input for scanning or analysis. One `.txt` file can be more convenient than multiple file references.

9. **Code Summarization / Embedding**  
Helps when generating embeddings or performing document-level transformations, as many ML frameworks accept a single document stream more easily.

## Security & Best Practices
- **Always audit** the script before running it, especially if you’re fetching it from an external URL.  
- **Keep your environment updated** (`bash`, `git`, `file` utility, etc.).  
- If you must run via cURL or `wget`, **double-check** the URL to ensure it points to your intended script, and consider validating checksums or signatures if available.  
- If distributing this script in a team environment, provide a **trusted, versioned** repository so team members can review changes.

## Parser Script (if needed)

If you want to **reconstruct** text files back into directories from the `.txt` file produced by this script, you can use an additional **parser script**. It reads each file’s metadata and contents from the generated `.txt` and recreates the corresponding directory structure on your system.

### Installation & Usage

1. **Clone or Download** the parser script (`parser.sh`) into any folder on your machine.  
2. **Make it executable**:
   
```bash
chmod +x parser.sh
```
   
4. **Run**:
   
```bash
./parser.sh <exported_txt_file>
```
   
   - Replace `<exported_txt_file>` with the actual `.txt` file (e.g., `my_project.txt`) you previously generated.  
   - The script will reconstruct all text files inside a folder named `restored_source_code`.

### How It Works
1. **Reads** each section in the `.txt` file, marked by the separator line.  
2. **Extracts** file metadata (filename, path) and the content of each file.  
3. **Creates** the appropriate directory structure and writes the file contents.  
4. **Logs** any files that were deemed non-text and displays them at the end.

## Contributing
Feel free to **fork** this project, open issues, or submit pull requests to improve features or compatibility. For major changes, please open a discussion first to align on the approach.

## License
```
Copyright 2024 Muhammad Utsman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

**Happy Exporting!**