# This is intended to be run in the /test-results/gcc-10 subdirectory
# in a Linux shell with g++-10 installed
#
cp ../*.cpp .
rm -f *.output
count=0
exe_count=0
g++-10 --version > gcc-version.output 2>&1
for f in *.cpp
do
    printf "Starting g++-10 %s\n" "$f"
    g++-10 -I/mnt/c/GitHub/cppfront/include -std=c++20 -pthread -o test.exe $f > $f.output 2>&1
    rm -f $f
    let count=count+1
    if test -f "test.exe"; then
        let exe_count=exe_count+1
        printf "    Starting executable\n"
        ./test.exe > $f.execution 2>&1
        rm -f test.exe
    fi
done
rm -f *.obj *.exp *.lib
printf "\nDone: %s .cpp tests compiled\n" "$count"
printf "\n      %s .cpp executables generated and run\n" "$exe_count"
