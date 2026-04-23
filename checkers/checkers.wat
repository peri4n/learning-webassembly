(module
  (memory $mem 1)

  (global $WHITE i32 (i32.const 2))
  (global $BLACK i32 (i32.const 1))
  (global $CROWN i32 (i32.const 4))

  (func $indexForPosition (param $x i32) (param $y i32) (result i32)
    (i32.add
      (local.get $x)
      (i32.mul
        (local.get $y)
        (i32.const 8)
      )
    )
  )

  ;; Offset = ( x + y * 8 ) * 4
  (func $offsetForPosition (param $x i32) (param $y i32) (result i32)
    (i32.mul
      (call $indexForPosition (local.get $x) (local.get $y))
      (i32.const 4)
    )
  )

  ;; Determine if a piece has been crowned
  (func $isCrowned (param $piece i32) (result i32)
    (i32.eq
      (i32.and 
        (local.get $piece) 
        (global.get $CROWN))
      (global.get $CROWN)))

  ;; Determine if a piece is white
  (func $isWhite (param $piece i32) (result i32)
    (i32.eq
      (i32.and 
        (local.get $piece) 
        (global.get $WHITE))
      (global.get $WHITE)))

  ;; Determine if a piece is black
  (func $isBlack (param $piece i32) (result i32)
    (i32.eq
      (i32.and 
        (local.get $piece) 
        (global.get $BLACK))
      (global.get $BLACK)))

  ;; Adds a crown to a given piece (no mutation)
  (func $withCrown (param $piece i32) (result i32)
    (i32.or 
      (local.get $piece) 
      (global.get $CROWN)))

  ;; Removes a crown from a given piece (no mutation)
  (func $withoutCrown (param $piece i32) (result i32)
    (i32.and 
      (local.get $piece) 
      (i32.const 3)))

  ;; Sets a piece on the board.
  (func $setPiece (param $x i32) (param $y i32) (param $piece i32)
    (i32.store
      (call $offsetForPosition
        (get_local $x)
        (get_local $y))
      (get_local $piece)))

  ;; Gets a piece from the board. Out of range causes a trap
  (func $getPiece (param $x i32) (param $y i32) (result i32)
    (if (result i32)
      (block 
        (result i32)
        (i32.and
          (call $inRange
            (i32.const 0)
            (i32.const 7)
            (get_local $x))
          (call $inRange
            (i32.const 0)
            (i32.const 7)
            (get_local $y))))
      (then
        (i32.load
          (call $offsetForPosition
          (get_local $x)
          (get_local $y))))
      (else
        (unreachable))))

  ;; Detect if values are within range (inclusive high and low)
  (func $inRange (param $low i32) (param $high i32) param $value i32) (result i32)
    (i32.and
      (i32.ge_s 
        (get_local $value) 
        (get_local $low))
      (i32.le_s 
        (get_local $value) 
        (get_local $high))))

  (export "offsetForPosition" (func $offsetForPosition))
  (export "isCrowned" (func $isCrowned))
  (export "isWhite" (func $isWhite))
  (export "isBlack" (func $isBlack))
  (export "withCrown" (func $withCrown))
  (export "withoutCrown" (func $withoutCrown))
)
