/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  var dismissCompletion: (() -> Void)?

  let duration = 0.8
  var presenting = true
  var originFrame = CGRect.zero

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let toView = transitionContext.view(forKey: .to)!
    let recipeView = presenting ? toView : transitionContext.view(forKey: .from)!

    let initialFrame = presenting ? originFrame : recipeView.frame
    let finalFrame = presenting ? recipeView.frame : originFrame

    let xScaleFactor = presenting ?
      initialFrame.width / finalFrame.width :
      finalFrame.width / initialFrame.width

    let yScaleFactor = presenting ?
      initialFrame.height / finalFrame.height :
      finalFrame.height / initialFrame.height

    let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

    if presenting {
      recipeView.transform = scaleTransform
      recipeView.center = CGPoint(
        x: initialFrame.midX,
        y: initialFrame.midY)
      recipeView.clipsToBounds = true
    }

    recipeView.layer.cornerRadius = presenting ? 20.0 : 0.0
    recipeView.layer.masksToBounds = true

    containerView.addSubview(toView)
    containerView.bringSubviewToFront(recipeView)

    UIView.animate(
      withDuration: duration,
      delay:0.0,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 0.2,
      animations: {
        recipeView.transform = self.presenting ? .identity : scaleTransform
        recipeView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        recipeView.layer.cornerRadius = !self.presenting ? 20.0 : 0.0
    }, completion: { _ in
      if !self.presenting {
        self.dismissCompletion?()
      }

      transitionContext.completeTransition(true)
    })
  }
}
