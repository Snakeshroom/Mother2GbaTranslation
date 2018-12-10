echo Copying fresh ROM...
cp m12fresh.gba m12.gba

echo Compiling text files...
pushd ScriptTool/ScriptTool/bin/Debug
mono ScriptTool.exe -compile -main -misc "..\..\..\..\working" "..\..\..\..\eb.smc" "..\..\..\..\m12fresh.gba"
popd

echo Assembling includes...
pushd working
../armips m12-includes.asm -sym includes-symbols.sym
popd

echo Compiling and assembling...
pushd compiled
if ! mono Amalgamator/Amalgamator/bin/Debug/Amalgamator.exe -r m12.gba -c 0x8100000 -d "../" -i vwf.c ext.c ; then
    echo Compile failed
    exit 1
fi
popd

mono SymbolTableBuilder/SymbolTableBuilder/bin/Debug/symbols.exe m12.sym armips-symbols.sym working/includes-symbols.sym

echo Success!
