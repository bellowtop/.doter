-- Treesitter is built into Neovim 0.12: parsers, queries and highlighting
-- are bundled in the runtime and enabled by default.
--
-- nvim-treesitter was archived (v0.10, 2024); its queries and custom
-- directives (`set-lang-from-info-string!` etc.) are incompatible with the
-- 0.12 query engine and error on every markdown fenced code block.
--
-- The only parser 0.12 does NOT bundle is `cpp`; it lives at ./parser/cpp.so
-- (machine-local build, loaded from the runtimepath).
return {}
