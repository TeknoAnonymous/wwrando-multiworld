.open "sys/main.dol"
.org @NextFreeSpace
.global custom_write_item_world_id
custom_write_item_world_id:
  stwu sp, -0x10 (sp)
  mflr r0
  stw r0, 0x14 (sp)
  lis r5, world_id@ha
  addi r5, r5, world_id@l
  lha r0, 0x1DC(r30)
  rlwinm r0, r0, 0x18, 0x18, 0x1f
  stw r0, 0x0(r5)

  lis r5, item_id@ha
  addi r5, r5, item_id@l
  lha r0, 0x1E0(r30)
  rlwinm r4, r0, 0x18, 0x18, 0x1f
  stw r4, 0x0(r5)

  lwz r0, 0x14 (sp)
  mtlr r0
  addi sp, sp, 0x10
  blr

.global adjust_salvage_chests
adjust_salvage_chests:
  stwu sp, -0x10 (sp)
  mflr r0
  stw r0, 0x14 (sp)


  stb r29, 0x34 (r3)
  lha r29, 0x1E0 (r21)
  rlwinm r29, r29, 0x18, 0x18, 0x1F
  stb r29, 0x36 (r3)
  lbz r29, 0x34 (r3)

  lwz r0, 0x14 (sp)
  mtlr r0
  addi sp, sp, 0x10
  blr

.global store_salvage_world_id
store_salvage_world_id:
  stwu sp, -0x10 (sp)
  mflr r0
  stw r0, 0x14 (sp)

  or r31, r4, r4
  mulli r6, r4, 0x38
  add r5, r3, r6

  lis r6, world_id@ha
  addi r6, r6, world_id@l
  lbz r0, 0x36 (r5)
  stw r0, 0x0 (r6)

  lis r6, item_id@ha
  addi r6, r6, item_id@l
  lbz r0, 0x34 (r5)
  stw r0, 0x00 (r6)

  li r0, 0x0
  stb r0, 0x36 (r5)

  lwz r0, 0x14 (sp)
  mtlr r0
  addi sp, sp, 0x10
  blr


.global world_id
world_id:
  nop
.global item_id
item_id:
  nop

.close

.open "files/rels/d_a_tbox.rel" ; Treasure chests
.org 0x2764 ; In actionOpenWait__8daTbox_cFv
  bl custom_write_item_world_id
.close

.open "sys/main.dol" ; Store World ID for Salvage Chests
.org 0x800CCAA4
  bl adjust_salvage_chests

.org 0x800CCBDC
  bl store_salvage_world_id
.close