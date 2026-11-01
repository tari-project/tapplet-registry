function greet(args)
    args = args or {}
    local name = args.name or "World"

    return "Hello, " .. name .. "!"
end

local function parse_entry(line)
    local fields = {}
    local current = {}
    local i = 1
    local len = #line

    while i <= len do
        local ch = line:sub(i, i)
        if ch == "|" then
            if i < len and line:sub(i + 1, i + 1) == "|" then
                table.insert(current, "|")
                i = i + 2
            else
                table.insert(fields, table.concat(current))
                current = {}
                i = i + 1
            end
        else
            table.insert(current, ch)
            i = i + 1
        end
    end
    table.insert(fields, table.concat(current))

    if #fields ~= 3 then
        return nil
    end
    return fields[1], fields[2], fields[3]
end

function save(args)
    args = args or {}
    if args.site == nil or args.username == nil or args.password == nil then
        return "Error: site, username and password are required"
    end

    local site = tostring(args.site)
    local username = tostring(args.username)
    local password = tostring(args.password)

    local function clean_string(s)
        return s:gsub("[|]", "||")
    end
    local single_string = clean_string(site) .. "|" .. clean_string(username) .. "|" .. clean_string(password)
    minotari_append_data("default", single_string)
    return "Saved password entry for " .. site
end


function load(args)
    args = args or {}
    local filter_site = args.site
    local data = minotari_load_data_entries("default") or {}
    local entries = {}
    for _, line in ipairs(data) do
        -- local line = row.value
        if line ~= nil and line ~= "" then
            local site, username, password = parse_entry(line)
            if site and username and password then
                if filter_site == nil or filter_site == "" or site == filter_site then
                    table.insert(entries, {
                        site = site,
                        username = username,
                        password = password
                    })
                end
            else
                print("Line did not match expected format: " .. line)
            end
        end
    end
    return entries
end

