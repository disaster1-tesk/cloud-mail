-- Latest UI settings require the selected interface theme to be stored in D1.
ALTER TABLE setting ADD COLUMN ui_theme TEXT NOT NULL DEFAULT 'workspace';
