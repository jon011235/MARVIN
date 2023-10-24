name: Verilog Build and Analysis

on:
  [pull_request]

jobs:
  build-and-analyze:
    runs-on: ubuntu-latest

    steps:
    - name: Verilog Compiler
      uses: jge162/verilog_compiler@1.0.0

    - run: |
        echo "Install required dependencies"
        sudo apt-get update
        sudo apt-get install iverilog
        sudo apt-get install verilator

    - run: |
        echo "Set executable permission on script file"
        chmod --recursive +x /*
        
    - run: |
        echo "Run, Build Application using script"
        VERILOG_FILES=find . -type f -name "*.v" -print0 | xargs -0 echo -n
        iverilog -o test_project $VERILOG_FILES
