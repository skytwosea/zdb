//   libedit funcs used:
//   -------------------
//   readline: at readline.h line 176
//       char *readline(const char *);
//   add_history: at readline.h line 180
//       int add_history(const char *)
//   history_length: at readline.h line 138
//       extern int history_base, history_length;
//   
//   history_list: at readline.h line 195
//       HIST_ENTRY **history_list(void);
//
//
//   assoc. libedit resources:
//   -------------------------
//   HIST_ENTRY: struct at readline.h line 58
//       typedef struct _hist_entry {
//           const char *line;
//           histdata_t data;
//       } HIST_ENTRY;
// ------------------------------------------

const c = @cImport({
    @cInclude("editline/readline.h");
});

pub const LibeditError = @import("errors.zig").LibeditError;

pub fn init() !void {
    if (c.rl_initialize() < 0) {
        return LibeditError.InitError;
    }
}


test "initialize libedit" {
    try init();
}
