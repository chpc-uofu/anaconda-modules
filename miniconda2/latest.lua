-- -*- lua -*-

help([[Module which sets the PATH variable for the latest miniconda 
       To check the available packages: conda list
]])
local home = os.getenv("HOME")
local version = myModuleVersion ()
local myana = pathJoin(home,"software/pkg/miniconda2")
setenv("PYTHONPREFIX",myana)
prepend_path("PATH",pathJoin(myana,"bin"))
-- prepend_path("PYTHONPATH",pathJoin(myana,"lib/python3.7/site-packages"))

whatis("Name         : Miniconda " .. version .. " Python 2")
whatis("Version      : " .. version .. " & Python 2")
whatis("Category     : Compiler")
whatis("Description  : Python environment")
whatis("URL          : https://conda.io/miniconda")
whatis("Installed on : --- ")
whatis("Modified on  : --- ")
whatis("Installed by : ---")

family("python")
