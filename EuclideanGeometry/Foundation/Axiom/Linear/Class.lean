import EuclideanGeometry.Foundation.Axiom.Basic.Class
import EuclideanGeometry.Foundation.Axiom.Linear.Line

/-!
# Hierarchy Classes of Linear Objects

Recall we have the following linear objects:
* `Vec` in Basic.Vector
* `Vec_nd` in Basic.Vector
* `Dir` in Basic.Vector
* `Proj` in Basic.Vector
* `Seg` in Linear.Ray
* `Seg_nd` in Linear.Ray DirFig
* `Ray` in Linear.Ray DirFig
* `DirLine` in Linear.Line DirFig
* `Line` in Linear.Line Fig
In this file, we assign linear objects into different abstract classes so that properties holds for the whole classes can be proved in a single theorem.

## Main Definitions

* `LinFig` : The class of linear figures, i.e. every three points in the carrier is colinear.
* `DirObj` : The class of objects with direction, i.e. equipped with a `toDir` method. It does not have to be a plane figure, e.g. `Vec_nd` and `Dir` itself.
* `DirFig` : The class of linear figures with direction. As a result, each figure is equipped with a `toDirLine` method.
* `ProjObj` : The class of objects with projective direction, i.e. equipped with a `toDir` method. It does not have to be a plane figure, e.g. `Vec_nd` and `Proj` itself.
* `ProjFig` : The class of linear figures with projective direction. As a result, each figure is equipped with a `toLine` method.

## Usage of Classes

* `LinFig` : A basic class.
* `DirObj` : Every two objects has a angle between them. This angle should be saved as Dir and has 3 representations, `Real.Angle` (mod 2π), `(-π, π]`, `[0, 2π)`.
* `DirFig` : `toDirLine` method, can define `odist`, `odist_sign`, `Left`, `Right`, `OnLine`, `OffLine`.
* `ProjObj` : parallel and perpendicular.
* `ProjFig` : `toLine` method, compatibility of carrier to Line.

Only theorems about `ProjFig` will be dealt in this file.

## Further Work

-/

noncomputable section
namespace EuclidGeom

class LinFig (α : (P : Type _) → [ EuclideanPlane P] → Type _) extends Fig α where
  colinear' : ∀ {P : Type _} [EuclideanPlane P] {A B C : P} {F : α P}, A LiesOn F → B LiesOn F → C LiesOn F → colinear A B C

class ProjObj (β : Type _) where
  toProj : β → Proj

class ProjFig (α : (P : Type _) → [ EuclideanPlane P] → Type _) extends LinFig α where
  toProj' : {P : Type _} → [EuclideanPlane P] → α P → Proj
  carrier_toproj_eq_toproj : ∀ {P : Type _} [EuclideanPlane P] {A B : P} {F : α P} (h : B ≠ A), A LiesOn F → B LiesOn F → (SEG_nd A B h).toProj = toProj' F

class DirObj (β : Type _) extends ProjObj β where
  toDir : β → Dir
  todir_toproj_eq_toproj : ∀ {G : β}, (toDir G).toProj = toProj G

class DirFig (α : (P : Type _) → [ EuclideanPlane P] → Type _) extends ProjFig α where
  toDir' : {P : Type _} → [EuclideanPlane P] → α P → Dir
  todir_toproj_eq_toproj : ∀ {P : Type _} [EuclideanPlane P] {F : α P}, (toDir' F).toProj = toProj' F

section fig_to_obj
variable {P : Type _} [EuclideanPlane P]

instance [ProjFig α] : ProjObj (α P) where
  toProj := ProjFig.toProj'

instance [DirFig α] : DirObj (α P) where
  toDir := DirFig.toDir'
  todir_toproj_eq_toproj := DirFig.todir_toproj_eq_toproj

end fig_to_obj

export ProjFig (toProj')
export ProjObj (toProj)
export DirFig (toDir')
export DirObj (toDir)

section instances
-- Vec is none of these. Id is LinFig.
instance : DirObj Vec_nd where
  toProj := Vec_nd.toProj
  toDir := Vec_nd.toDir
  todir_toproj_eq_toproj := rfl

instance : DirObj Dir where
  toProj := Dir.toProj
  toDir := id
  todir_toproj_eq_toproj := rfl

instance : ProjObj Proj where
  toProj := id

instance : LinFig Seg where
  carrier := Seg.carrier
  colinear' := sorry

instance : DirFig Seg_nd where
  carrier := fun s => s.1.carrier -- can be rewrite to `Seg_nd.carrier` soon
  colinear' := sorry
  toProj' := Seg_nd.toProj
  carrier_toproj_eq_toproj := sorry
  toDir' := Seg_nd.toDir
  todir_toproj_eq_toproj := rfl

instance : DirFig Ray where
  carrier := Ray.carrier
  colinear' := sorry
  toProj' := Ray.toProj
  carrier_toproj_eq_toproj := sorry
  toDir' := fun r => r.toDir
  todir_toproj_eq_toproj := rfl

instance : DirFig DirLine where
  carrier := DirLine.carrier
  colinear' := DirLine.linear
  toProj' := DirLine.toProj
  carrier_toproj_eq_toproj := sorry
  toDir' := DirLine.toDir
  todir_toproj_eq_toproj := rfl

instance : ProjFig Line where
  carrier := Line.carrier
  colinear' := Line.linear
  toProj' := Line.toProj
  carrier_toproj_eq_toproj := sorry

end instances

/-
variable {P : Type _} [EuclideanPlane P] (A B C : P) [h : ProjFig α] (F : α P)

#check toProj F
example : toProj F = toProj' F := rfl
#check A LiesOn F
-/

end EuclidGeom
