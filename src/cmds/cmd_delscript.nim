import os, strutils, terminal, common, sequtils

proc delScript*(name: string) =
  ## Deletes an existing script.
  
  ensureValidFS()

  let
    uppername = name.capitalizeAscii
    lowername = name.toLower

  if not fileExists("scripts/$1.gdns" % uppername):
    quit "'$1' does not exist. (Nim-style case sensitivity?)" % uppername, -1

  echo "Are you sure you want to delete the script '$1'? (y/N)" % uppername
  case getch().toLowerAscii
  of 'y':
    removeFile("src/$1.nim" % lowername)
    removeFile("scripts/$1.gdns" % uppername)

    var stubLines = toSeq(lines("src/stub.nim")).filterIt(lowername notin it and it != "")
    var stub = open("src/stub.nim", fmWrite)
    for line in stubLines:
      stub.write(line & '\n')
    stub.close()

    echo "Successfully deleted script '$1'." % uppername
  else:
    echo "Aborted."