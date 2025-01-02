local REPO_URL = "https://github.com/automationaddict/ansible.git"

local function create_tmp_dir()
    -- Create the tmp directory
    local tmp_dir = "./tmp" -- Directory path

    print("Check if the directory exists and remove it")
    if os.execute("test -d " .. tmp_dir) then
        -- Remove the existing directory
        os.execute("rm -rf " .. tmp_dir)
    end

    print("Create the directory")
    if os.execute("mkdir -p " .. tmp_dir) then
        print(tmp_dir .. " directory has been created.")
    end
end

-- First run create tmp directory
create_tmp_dir()

-- Function to run a shell command and check its result
local function run_command(command)
    local output_file = "./tmp/setup_log.txt"
    local ok, exit_type, exit_code = os.execute(command .. " >> " .. output_file .. " 2>&1")
    -- print("Ok:", ok)
    -- print("Exit Type:", exit_type)
    -- print("Exit Code:", exit_code)
    if exit_code == 0 then
        return true
    end
    print("Command failed: " .. command)
    print("Check the log at " .. output_file .. " for details")
    return false
end

print("Updating, Upgrading, and Cleaning up the system")

-- Update package list
print("Updating package list")
if run_command("sudo apt-get update -y") then
    print("Package list updated successfully")
end

-- Upgrade packages
print("Upgrading packages")
if run_command("sudo apt-get upgrade -y") then
    print("Packages upgraded successfully")
end

-- Autoremove packages
print("Removing unused packages")
if run_command("sudo apt-get autoremove -y") then
    print("Unused packages removed successfully")
end

-- Check if software-properties-common is installed
print("Checking if software-properties-common is installed")

if run_command("dpkg -l | grep -q software-properties-common") then
    print("software-properties-common is already installed")
else
    print("software-properties-common is not installed")
    if run_command("sudo apt-get install -y software-properties-common") then
        print("software-properties-common installed successfully")
    end
end

-- Check if ansible repository is present
print("Check if Ansible repository is present")

if run_command("grep -r '^deb .*ansible/ansible' /etc/apt/sources.list.d/") then
    print("Ansible repository is already present")
else
    print("Adding Ansible repository")
    if run_command("sudo apt-add-repository -y --update ppa:ansible/ansible") then
        print("Ansible repository has been added successfully")
    end
end

-- Check if Ansible is installed
print("Checking if Ansible is installed")

if run_command("dpkg -l | grep -q ansible") then
    print("Ansible is already installed")
else
    print("Ansible is not installed")
    if run_command("sudo apt-get install -y ansible") then
        print("Ansible has been installed successfully")
    end
end

-- Check if Python3 is installed
print("Checking if Python 3 is installed")

if run_command("dpkg -l | grep -q python3") then
    print("Python 3 is already installed")
else
    print("Python 3 is not installed")
    if run_command("sudo apt-get install -y python3") then
        print("Python 3 has been installed successfully")
    end
end

-- Check if Python3 Pip is installed
print("Checking if Python 3 Pip is installed")

if run_command("dpkg -l | grep -q python3-pip") then
    print("Python 3 Pip is already installed")
else
    print("Python 3 Pip is not installed")
    if run_command("sudo apt-get install -y python3-pip") then
        print("Python 3 Pip has been installed successfully")
    end
end

-- Check if Python3 Watchdog is installed
print("Checking if Python 3 Watchdog is installed")

if run_command("dpkg -l | grep -q python3-watchdog") then
    print("Python 3 Watchdog is already installed")
else
    print("Python 3 Watchdog is not installed")
    if run_command("sudo apt-get install -y python3-watchdog") then
        print("Python 3 Watchdog has been installed successfully")
    end
end

-- Check if Python3 ArgComplete is installed
print("Checking if Python 3 ArgComplete is installed")

if run_command("dpkg -l | grep -q python3-argcomplete") then
    print("Python 3 ArgComplete is already installed")
else
    print("Python 3 ArgComplete is not installed")
    if run_command("sudo apt-get install -y python3-argcomplete") then
        print("Python 3 ArgComplete been installed successfully")
    end
end

-- Ensure that the global Python 3 ArgComplete activation script is executed
print("Checking if activate-global-python-argcomplete3 has been executed")

if run_command("sudo activate-global-python-argcomplete3") then
    print("activate-global-python-argcomplete3 has been executed successfully")
end

-- Clone the Ansible repository
print("Clone a git repository")

local temp_dir = os.getenv("HOME") .. "/ansible.tmp"
local target_dir = os.getenv("HOME") .. "/ansible"

-- Clone the repository
if run_command("git clone " .. REPO_URL .. " " .. temp_dir) then
    create_tmp_dir()
    print("Repository cloned successfully into " .. temp_dir)
end

-- Check if the directory exists
if run_command("test -d " .. target_dir) then
    print(temp_dir .. " already exists.")
    print("Do you want to overwrite the main directory? (yes/no): ")
    local answer = io.read()
    if answer == "yes" then
        print("Moving temp directory to target directory")
        run_command("mv -f " .. temp_dir .. " " .. target_dir)
    else
        run_command("rm -rf " .. temp_dir)
        print("Exiting without overwriting the directory.")
        os.exit(1)
    end
else
    print("Creating target directory")
    run_command("mv -f " .. temp_dir .. " " .. target_dir)
    os.exit(1)
end
