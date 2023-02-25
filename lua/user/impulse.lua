local status_ok, impulse = pcall(require, "impulse")
if not status_ok then
	return
end

impulse.setup({
    -- Your notion API key. 
    -- Get one by creating an integration here: https://www.notion.so/my-integrations
    -- This plugin does not update or modify any pages, so you can set
    -- "Read content" as the only option if you prefer.
    --
    -- It is possible that impulse will be updated with write abilities at some
    -- point.
    --
    -- DEFAULT: os.getenv "NOTION_SECRET"
    -- api_key="secret_xx6rjO4W1cTOWoeS2qv4fAuiXF9CfbfrQHQ0ATbWrma",

    -- If always_refetch is true, every time you search-and-select or follow a
    -- link, that page's block set will be pulled again. Useful if you are
    -- following live updates.
    --
    -- DEFAULT: false
    -- always_refetch: false or true

    -- Whether or not to allow `follow_link` to open a non-impulse URL.
    -- If false, nothing will happen with follow_link.
    -- If true, impulse will use xdg-open.
    -- If a path is specified or name of a browser in $PATH, impulse will use it.
    --
    -- DEFAULT: false
    -- open_in_browser: false, true or "string browser"
})

