import os
import re
import csv

def extract_r_libraries(file_path):
    r_libraries = set()
    with open(file_path, 'r') as f:
        lines = f.readlines()
        for line in lines:
            match = re.match(r'^\s*library\((.*?)\)', line)
            if match:
                r_libraries.add(match.group(1))
    return r_libraries

def extract_python_modules(file_path):
    python_modules = set()
    with open(file_path, 'r') as f:
        lines = f.readlines()
        for line in lines:
            match = re.match(r'^\s*import\s+(.*?)\s*$', line)
            if match:
                python_modules.add(match.group(1))
            else:
                match = re.match(r'^\s*from\s+(.*?)\s+import\s+', line)
                if match:
                    python_modules.add(match.group(1))
    return python_modules

def find_scripts(directory):
    r_scripts = {}
    python_scripts = {}

    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(".R"):
                r_script_path = os.path.join(root, file)
                r_libraries = extract_r_libraries(r_script_path)
                r_scripts[r_script_path] = r_libraries

            elif file.endswith(".py"):
                python_script_path = os.path.join(root, file)
                python_modules = extract_python_modules(python_script_path)
                python_scripts[python_script_path] = python_modules

    return r_scripts, python_scripts

def export_to_csv(r_scripts_dict, python_scripts_dict):
    with open("citations.csv", mode="w", newline="") as csvfile:
        fieldnames = ["Programming Language", "Filename", "Module/Import"]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()

        for r_script, r_libraries in r_scripts_dict.items():
            for library in r_libraries:
                writer.writerow({"Programming Language": "R", "Filename": r_script, "Module/Import": library})

        for python_script, python_modules in python_scripts_dict.items():
            for module in python_modules:
                writer.writerow({"Programming Language": "Python", "Filename": python_script, "Module/Import": module})

if __name__ == "__main__":
    parent_directory = "."   
    r_scripts_dict, python_scripts_dict = find_scripts(parent_directory)
    export_to_csv(r_scripts_dict, python_scripts_dict)
