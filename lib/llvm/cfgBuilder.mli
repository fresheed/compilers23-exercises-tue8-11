exception CFGConstructionError of string

type cfg_builder

type buildlet = cfg_builder -> cfg_builder
val id_buildlet: buildlet
val seq_buildlets: buildlet list -> buildlet

val is_labelled : cfg_builder -> bool

val add_alloca:  Util.Ll.uid * Util.Ll.ty -> buildlet
val add_insn: Util.Ll.uid option * Util.Ll.insn -> buildlet
val term_block: Util.Ll.terminator -> buildlet
val start_block: Util.Ll.lbl -> buildlet

val empty_cfg_builder: cfg_builder
val get_cfg: cfg_builder -> Util.Ll.cfg