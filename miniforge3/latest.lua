-- -*- lua -*-

-- SYNTAX NOTES: All comments in .lua files begin with a "--" 

-- #############################################################################
-- ######################### EDIT THIS ONLY: ###################################
-- #############################################################################

-- Tell the people what this module includes and when it was last updated! 

whatis("Name         : Miniforge3 with Mamba vX.X.X / Conda XX.X.0 ")
whatis("Version      : ")
whatis("Category     : Compiler")
whatis("Description  : ")
whatis("URL          : https://github.com/conda-forge/miniforge/releases/")
whatis("Installed on : ")
whatis("Modified on  : ")
whatis("Installed by : ")

-- Change mymambapath if the installation is in a different place in your home directory.
-- If you want to be the only person who can use this module, you can enter the path as 
-- a relative path from the base of your home directory. If you want others to be able to
-- use this module, then you'll want to set it as the absolute path. 

-- change myanapath if the installation is in a different place in your home
-- note that this is a relative path from the base of your home directory
local mymambapath = "software/pkg/miniforge3"
-- if you want to share this miniforge installation with others, use the full
-- path
--local mymambapath = "/uufs/chpc.utah.edu/common/home/u0123456/software/pkg/miniforge3"

-- #############################################################################
-- ######################### DONT EDIT BELOW HERE: #############################
-- #############################################################################
help([[Module which sets the PATH variable for user instaled miniconda 
       To check the available packages: conda list
]])

-- #############################################################################
-- ######################### CONFIGURATION #####################################
-- #############################################################################
-- This section is defining the path to your Miniforge3 installation (mymamba) 
-- based on "the mymambapath" variable you specified earlier. 

--Retrieve the version of the module being loaded.
local version = myModuleVersion ()

-- Check if "myanapath" contains the string "uufs".
if (string.find(mymambapath,"uufs") == nil) then
-- If "mymambapath" doesn't contain "uufs" it assumes that the path is relative and 
-- prepends the user's home directory path to it.
  mymamba = pathJoin(os.getenv("HOME"),mymambapath)
else
-- If "mymambapath" does contain "uufs" , it uses the absolute path as-is.
  mymamba = mymambapath
end

-- Once we have the full path to your installation, these next lines sets the 
-- environment variable, "MINIFORGE3_ROOT", to this path and prepends the bin 
-- directory within "mymamba" to the PATH environment variable. This allows the 
-- shell to find the python and mamba executables.

-- Set the environment variable that points to the Miniforge3 root directory
-- and set vars that restrict Mamba to reference only environments in this installation.
setenv("MINIFORGE3_ROOT", mymamba) -- Make sure it know where miniforge3 root is! 
setenv("CONDA_ENVS_PATH", pathJoin(mymamba, "envs"))  -- Restrict to environments in THIS installation
setenv("MAMBA_ROOT_PREFIX", mymamba)  -- Ensure Mamba uses this installation's prefix

-- Prepend the `bin` directory of Miniforge3 to the PATH so that these vars are found first.
prepend_path("PATH", pathJoin(mymamba, "bin"))

-- #############################################################################
-- ###################### ENVIRONMENT SETUP ON LOAD ############################
-- #############################################################################
-- This section is executed when the module is loaded. It sources the mamba.sh 
-- (or mamba.csh) script, which sets up the environment needed to use Mamba/Conda.
-- Since July, 2019 to enable virtual environments, we have to source conda.sh and 
-- mamba.sh upon module load. 

-- Only do this if user is "loading" the module: 
if (mode() == "load") then
  -- Ensure conda is properly initialized for the current shell
  io.stdout:write("source "..mymamba.."/etc/profile.d/conda."..myShellType().."\n")  
  
    -- & Also source the Mamba initialization script (which relies on the Conda version)... 
  io.stdout:write("source "..mymamba.."/etc/profile.d/mamba."..myShellType().."\n")
end

-- #############################################################################
-- ##################### CLEANUP ON MODULE UNLOAD ##############################
-- #############################################################################
-- This section handles the cleanup when the module is unloaded. It removes environment 
-- variables, shell functions, and paths that were set when loading the module. 

-- Only do this if the user is "unloading" the module: 
if (mode() == "unload") then

  -- Remove these directories from PATH (where conda/mamba & its executables are stored).
  remove_path("PATH", pathJoin(mymamba, "bin"))
  remove_path("PATH", pathJoin(mymamba, "condabin"))

  -- Generate the appropriate cleanup commands based on the user's shell type.
  if (myShellType() == "csh") then
    -- For C shell: Unset environment variables and unalias commands specific to csh.
    cmd = "unsetenv CONDA_EXE; unsetenv CONDA_PYTHON_EXE; unsetenv CONDA_SHLVL; " ..
          "unsetenv _CONDA_EXE; unsetenv _CONDA_ROOT;" ..
          "unsetenv MAMBA_NO_BANNER; unalias conda; " ..  -- up to here what's actually being set in conda/mamba.csh
          "unsetenv _CE_CONDA; unsetenv _CE_M; " ..  -- this has been set in the past, may be still used
          "unsetenv CONDA_PREFIX; unsetenv CONDA_DEFAULT_ENV; " ..
          "unsetenv CONDA_PROMPT_MODIFIER; unsetenv CONDA_ENV_PATH; " ..
          "unsetenv CONDA_BACKUP_PATH; unsetenv MAMBA_ROOT_PREFIX; "
  else
    -- For bash and other POSIX shells: Unset environment variables and shell functions.
    cmd = "unset CONDA_EXE; unset _CE_CONDA; unset _CE_M; " ..
          "unset CONDA_PYTHON_EXE; unset CONDA_SHLVL; " ..
          "unset MAMBA_ROOT_PREFIX; " ..
          "unset -f __m_activate; unset -f __conda_reactivate; " ..
          "unset -f __conda_hashr; unset -f conda; " ..
          "unset CONDA_PREFIX; unset CONDA_DEFAULT_ENV; " ..
          "unset CONDA_PROMPT_MODIFIER; unset CONDA_ENV_PATH; " ..
          "unset _CONDA_EXE; unset _CONDA_ROOT; unset CONDA_BACKUP_PATH; " ..
          "unset MAMBA_NO_BANNER; " ..
          "unset -f __conda_activate; unset -f __conda_reactivate; " ..
          "unset -f __conda_hashr; unset -f conda; unset -f __conda_exe"
  end

  -- Execute the cleanup command.
  execute{cmd=cmd, modeA={"unload"}}
end

-- This module belongs in the python family. 
family("python")
