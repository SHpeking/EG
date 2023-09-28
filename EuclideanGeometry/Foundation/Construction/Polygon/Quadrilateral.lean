import EuclideanGeometry.Foundation.Axiom.Position.Convex
import EuclideanGeometry.Foundation.Axiom.Triangle.Basic
import EuclideanGeometry.Foundation.Axiom.Linear.Parallel

/-!
# Quadrilateral

In this file we define general quadrilaterals as four points on the plane and convex quadrilaterals.

## Important Definitions
* `Quadrilateral P` : general quadrilaterals on the plane `P`, i.e. four points on `P`
* `Quadrilateral_cvx P` : convex quadrilaterals on the plane `P`

## Notation
* `QDR A B C D` : notation for quadrilateral `A B C D`

## Implementation Notes
Currently, we just defines general quadrilaterals and convex quadrilaterals. There are more classes in between. For example, quadrilateral without self-intersection, quadrilateral of non-degenerate (which means it does not self-intersect and not degenerate to a triangle). 
Of course many definitions work on these classes already, but without necessarity in application, we will not formalize these class for present.
-/

noncomputable section
namespace EuclidGeom

/-- Class of Quadrilateral: A quadrilateral consists of four points; it is the generalized quadrilateral formed by these four points -/
@[ext]
class Quadrilateral (P : Type _) [EuclideanPlane P] where
  point₁ : P
  point₂ : P
  point₃ : P
  point₄ : P

/-- For four points $A$ $B$ $C$ $D$ on a plane, instead of writing Quadrilateral.mk $A$ $B$ $C$ $D$ for the quadrilateral formed by $A$ $B$ $C$ $D$, we use QDR $A$ $B$ $C$ $D$ to denote such a quadrilateral. -/
scoped notation "QDR" => Quadrilateral.mk

namespace Quadrilateral
variable {P : Type _} [EuclideanPlane P] {qdr : Quadrilateral P}

/-- Given a quadrilateral qdr, qdr.edge₁₂ is the edge from the first point to the second point of a quadrilateral. -/
def edge₁₂ : Seg P := SEG qdr.1 qdr.2

/-- The edge from the second point to the third point of a quadrilateral -/
def edge₂₃ : Seg P := SEG qdr.2 qdr.3

/-- The edge from the third point to the fourth point of a quadrilateral -/
def edge₃₄ : Seg P := SEG qdr.3 qdr.4

/-- The edge from the fourth point to the first point of a quadrilateral -/
def edge₄₁ : Seg P := SEG qdr.4 qdr.1

/-- The diagonal from the first point to the third point of a quadrilateral -/
def diag₁₃ : Seg P := SEG qdr.1 qdr.3

/-- The diagonal from the second point to the fourth point of a quadrilateral -/
def diag₂₄ : Seg P := SEG qdr.2 qdr.4

end Quadrilateral

/- 
`Should change here, first should define a single propert IsConvex then define the class, this will enable the class to defined as adding this single property`
`and we can write QDR_cvx A B C D h`
-/
/--
Class of Convex Quadrilateral: A convex quadrilateral is quadrilateral such that 
1. both diagnals are non-degenerate, 
2. two diagonals are not parallel to each other,
3. the interior of two diagonals intersect at one point, i.e. the intersection point of the underlying lines of the diagonals lies in the interior of both diagonals.
-/
@[ext]
class Quadrilateral_cvx (P : Type _) [EuclideanPlane P] extends Quadrilateral P where
  nd₁₃ : point₃ ≠ point₁ 
  nd₂₄ : point₄ ≠ point₂
  diag_not_para : ¬ SEG_nd point₂ point₄ nd₂₄ ∥ (LinearObj.seg_nd (SEG_nd point₁ point₃ nd₁₃))
  diag_intx : Line.inx (SEG_nd point₁ point₃ nd₁₃).toLine (SEG_nd point₂ point₄ nd₂₄).toLine diag_not_para LiesInt (SEG point₁ point₃) ∧ Line.inx (SEG_nd point₁ point₃ nd₁₃).toLine (SEG_nd point₂ point₄ nd₂₄).toLine diag_not_para LiesInt (SEG point₂ point₄)

-- `do we need the following notation?`
-- scoped notation "QDR_cvx" => Quadrilateral_cvx.mk
-- `I think it is better to state (qdr_cvx : Quadrilateral_cvx P) (A = qdr_cvx.point₁) ...`

namespace Quadrilateral_cvx
variable {P : Type _} [EuclideanPlane P] {qdr_cvx : Quadrilateral_cvx P}

/-- Given a convex quadrilateral qdr_cvx, diagonal from the first point to the second point is not degenerate, i.e. the second point is not equal to the first point. -/
theorem diag₁₃_nd : qdr_cvx.point₃ ≠ qdr_cvx.point₁ := qdr_cvx.nd₁₃

/-- Given a convex quadrilateral qdr_cvx, diagonal from the first point to the second point is not degenerate, i.e. the second point is not equal to the first point. -/
theorem diag₂₄_nd : qdr_cvx.point₄ ≠ qdr_cvx.point₂ := qdr_cvx.nd₂₄

/-- The non-degenerate diagonal from the first point and third point of a convex quadrilateral -/
def diag_nd₁₃ : Seg_nd P := SEG_nd qdr_cvx.point₁ qdr_cvx.point₃ qdr_cvx.nd₁₃

/-- The non-degenerate diagonal from the second point and fourth point of a convex quadrilateral -/
def diag_nd₂₄ : Seg_nd P := SEG_nd qdr_cvx.point₂ qdr_cvx.point₄ qdr_cvx.nd₂₄

/-- Given a convex quadrilateral qdr_cvx, edge from the first point to the second point is not degenerate, i.e. the second point is not equal to the first point. -/
theorem edge₁₂_nd : qdr_cvx.point₂ ≠ qdr_cvx.point₁ := sorry

/-- Given a convex quadrilateral qdr_cvx, edge from the first point to the second point is not degenerate, i.e. the second point is not equal to the first point. -/
theorem edge₂₃_nd : qdr_cvx.point₃ ≠ qdr_cvx.point₂ := sorry

/-- Given a convex quadrilateral qdr_cvx, edge from the first point to the second point is not degenerate, i.e. the second point is not equal to the first point. -/
theorem edge₃₄_nd : qdr_cvx.point₄ ≠ qdr_cvx.point₃ := sorry

/-- Given a convex quadrilateral qdr_cvx, edge from the first point to the second point is not degenerate, i.e. the second point is not equal to the first point. -/
theorem edge₄₁_nd : qdr_cvx.point₁ ≠ qdr_cvx.point₄ := sorry

/-- The edge from the first point to the second point of a quadrilateral -/
def edge_nd₁₂ : Seg_nd P := SEG_nd qdr_cvx.point₁ qdr_cvx.point₂ qdr_cvx.edge₁₂_nd

/-- The edge from the second point to the third point of a quadrilateral -/
def edge_nd₂₃ : Seg_nd P := SEG_nd qdr_cvx.point₂ qdr_cvx.point₃ qdr_cvx.edge₂₃_nd

/-- The edge from the third point to the fourth point of a quadrilateral -/
def edge_nd₃₄ : Seg_nd P := SEG_nd qdr_cvx.point₃ qdr_cvx.point₄ qdr_cvx.edge₃₄_nd

/-- The edge from the fourth point to the first point of a quadrilateral -/
def edge_nd₄₁ : Seg_nd P := SEG_nd qdr_cvx.point₄ qdr_cvx.point₁ qdr_cvx.edge₄₁_nd

end Quadrilateral_cvx

section is_convex
variable {P : Type _} [EuclideanPlane P]

def Quadrilateral.IsConvex (qdr : Quadrilateral P) : Prop := by
  by_cases ((qdr.point₃ ≠ qdr.point₁) ∧ (qdr.point₄ ≠ qdr.point₂))
  · by_cases g : (¬ SEG_nd qdr.point₂ qdr.point₄ h.2 ∥ (LinearObj.seg_nd (SEG_nd qdr.point₁ qdr.point₃ h.1)))
    · exact Line.inx (SEG_nd qdr.point₁ qdr.point₃ h.1).toLine (SEG_nd qdr.point₂ qdr.point₄ h.2).toLine g LiesInt (SEG qdr.point₁ qdr.point₃) ∧ Line.inx (SEG_nd qdr.point₁ qdr.point₃ h.1).toLine (SEG_nd qdr.point₂ qdr.point₄ h.2).toLine g LiesInt (SEG qdr.point₂ qdr.point₄)
    · exact False
  · exact False

theorem Quadrilateral_cvx.is_convex (qdr_cvx : Quadrilateral_cvx P) : qdr_cvx.1.IsConvex := sorry

def Quadrilateral_cvx.mk_is_convex {qdr : Quadrilateral P} (h : qdr.IsConvex) : Quadrilateral_cvx P where
  toQuadrilateral := qdr
  nd₁₃ := sorry
  nd₂₄ := sorry
  diag_not_para := sorry
  diag_intx := sorry

end is_convex

section criteria
/-
the criteria of a quadrilateral being convex
-/

end criteria

section property
-- properties of convex quadrilateral `to be added`

end property

end EuclidGeom