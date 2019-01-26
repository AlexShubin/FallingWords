platform :ios, '11.0'

use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'RxSwift'
  pod 'RxCocoa'
end

target 'FallingWords' do
  shared_pods
  pod 'RxOptional'
  pod 'RxFeedback'

  pod 'SwiftLint'
  pod 'SwiftGen'
end

target 'FallingWordsTests' do
  shared_pods
  pod 'RxTest'
end
