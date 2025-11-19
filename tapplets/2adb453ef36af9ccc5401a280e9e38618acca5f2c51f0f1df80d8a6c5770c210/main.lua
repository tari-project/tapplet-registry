function greet(args)
    local name = args.name or "World"

    return "Hello, " .. name .. "!"
end

function save(args) 

    if args.site == nil or args.username == nil or args.password == nil then
        return "Error: site, username and password are required"
    end

    local site = args.site
    local username = args.username
    local password = args.password

    local function clean_string(s)
        return s:gsub("[|]", "||")
    end
    local single_string = clean_string(site) .. "|" .. clean_string(username) .. "|" .. clean_string(password)
    minotari_append_data("default", single_string)
end


function load(args)
    local data = minotari_load_data_entries("default")
    local entries = {}
    for i, line in ipairs(data) do
        -- local line = row.value
        if line ~= nil and line ~= "" then
            if string.match(line, "([^|]*)|([^|]*)|([^|]*)") then 
                local site, username, password = string.match(line, "([^|]*)|([^|]*)|([^|]*)")
                if site and username and password then
                    local function restore_string(s)
                        return s:gsub("||", "|")
                    end
                    table.insert(entries, {
                        site = restore_string(site),
                        username = restore_string(username),
                        password = restore_string(password)
                    })
                end
            else 
                print("Line did not match expected format: " .. line)
            end
        end
    end
    return entries
end

