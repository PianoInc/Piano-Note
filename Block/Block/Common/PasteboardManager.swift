//
//  PasteboardManager.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 5..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

struct PasteboardManager {
    
    /**
     # what
     지정된 문단들을 복사한다.
     
     # when
     NoteViewController의 tapCopy:, 각 PieceCell의 tapCopy:
     
     # how
     피아노 로딩 애니메이션을 돌리고 글로벌 큐에서 비동기로 작동
     selectedInexPaths 를 mapping하여, NSattributedString 배열로 만들고 reduce로 합친다. 이때, 매번 개행을 붙여준다. 이미지 piece 내에 여러개의 이미지들이 있을 때에 이미지 한 장을 한 문단으로 가정하고 여러 문단으로 붙인다.
     
     # why
     빠른 편집의 한 기능으로 제공하기 위해
     */
    static func copyParagraphs(blocks: [Block]) {
        //1. 우선 blocks를 NSAttributedString으로 만들기 -> block.nsAttributedText
        //2. 그 다음 붙일 때 개행을 삽입해주기
        //3. 이걸 데이터로 변환하기
        //4. 테스트해보기
        
        //우선은 텍스트밖에 없으므로 String으로 만든다.
        var string = ""
        blocks.forEach { (block) in
            switch block.type {
            case .plainText:
                let plainStr = (block.text ?? "") + "\n"
                string.append(plainStr)
            case .checklistText:
                let checkStr = "- " + (block.text ?? "") + "\n"
                string.append(checkStr)
                
            case .orderedText:
                let orderStr = "\((block.orderedTextBlock?.num ?? 0)). "  + "\n"
                string.append(orderStr)
                
            case .unOrderedText:
                let unOrderStr = "* " + (block.text ?? "") + "\n"
                string.append(unOrderStr)
                
            case .separator:
                let separatorStr = "---" + "\n"
                string.append(separatorStr)
            default:
                print("TODO: 데이터 추가되면 이곳 작업해줘야함")
            }
        }
        
        PasteBoard.general.string = string
        
        
    }
    
    /**
     
     # what
     클립보드에 있는 데이터를 piece로 변환한다.
     
     # when
     TextView의 paste:
     단, 다음의 사전처리 작업이 필요하다. paste:에서 현재 뷰에서 변경된 내용들을 모델에 저장시켜야함
     
     # how
     로딩 애니메이션은 메인쓰레드에서 돌리고 무거운 변환 작업은 글로벌 큐에서 비동기로 돌린다.
     현재 Piece에 텍스트가 있다면 NSMutableAttributedString을 만들어 대입시켜놓고, 그 뒤에 pasteboard의 data에서 추출한 NSAttributedString을 붙인다.
     enumerate를 돌아 attachment가 있는 지 확인하고, 있다면 전 후(전은 0보다 크거나 같아야하며 후는 글자 수보다 작거나 같아야 함)에 개행이 들어가 있는 지 확인해서 없다면 넣어준다.
     그다음 string를 활용해 range를 구하여 궁극적으로 NSAttributedString 배열을 만든다(플레이그라운드에 예제 적어놓음).
     적절한 piece 모델로 만들기 위해 배열의 요소마다 attachment를 체크하고, 있다면 타입을 체크해서 적절한 모델로 바꿔준다.
     attachment가 없다면 string과 attributes로 분리해서 텍스트 관련 모델을 만든다. 여기서도 서식의 유무를 판단해서 적절한 piece로 변환시킨다.
     현재 piece는 코어데이터에서 지워주고, 해당 indexPath에 Piece 배열을 삽입한다.
     
     모든 작업이 끝난 경우에,
     마지막 뷰모델이 텍스트 타입이 아니면 추가적으로 비어있는 TextPiece 모델을 만들어준다. 그리고 마지막 뷰모델이 텍스트 모델인 게 확정 되었으므로, 텍스트뷰의 마지막 위치에 커서를 세팅시키고, 키보드를 띄워준다.
     인자로 받은 selectedIndexPaths로 해당하는 모델들에 접근하여 순차적으로 NSAttributedString으로 만들어주며 append한다. 이때, 매번 개행을 붙여준다. 이미지 piece 내에 여러개의 이미지들이 있을 때에 이미지 한 장을 한 문단으로 가정하고 여러 문단으로 붙인다.
     
     # why
     텍스트뷰가 아닌 테이블 뷰 엔진에 맞는 데이터 구조로 변환시키기 위해
     */
    static func pasteParagraphs(currentBlock: Block, to: Note) {
        
    }
    
    /**
     # what
     메모화면으로 이동했을 때, pasteboard에 데이터가 있다면, 보여주기, 유니버셜 클립보드에 데이터가 있을 때에도 마찬가지로 보여주기
     
     # when
     노트 뷰로 진입했을 때
     
     # how
     TODO: 적어야함
     
     # why
     보통 외부에서 붙여넣기를 할 때, 외부에서 복사한 뒤, 메모 앱으로 와서 메모화면을 띄우고 붙여넣기 버튼을 누르는데 이 걸 자동화시키기 위함. 단, 붙여넣기
    */
    static func suggestPasteIfNeeded() {
        
    }
    
}
