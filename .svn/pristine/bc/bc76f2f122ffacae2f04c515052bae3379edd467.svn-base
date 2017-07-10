



// We're using a global variable to store the number of occurrences
var MyApp_SearchResultCount = 0;

function zxSearchKeyword(keyword)
{
    MyApp_SearchResultCount = 0;
    zxSearchKeywordForElement(document.body, keyword.toLowerCase());
}

function zxSearchKeywordForElement(element, keyword)
{
    if(!element)
        return;
    if (element.nodeType == 3)   // Text node
    {
        while(true)
        {
            var value = element.nodeValue;  // Search for keyword in text node
            var idx = value.toLowerCase().indexOf(keyword);
            if (idx < 0) break;             // not found, abort
            
            //element更新为剩下未搜索的文本
            element = document.createTextNode(value.substr(idx+keyword.length));
            MyApp_SearchResultCount++;
        }
    }else if (element.nodeType == 1)// Element node
    {
        if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select')
            for (var i=element.childNodes.length-1; i>=0; i--)
                //递归调用
                zxSearchKeywordForElement(element.childNodes[i],keyword);
    }
}

// the main entry point to start the search
function MyApp_HighlightAllOccurencesOfString(keyword) {
    MyApp_RemoveAllHighlights();
    MyApp_HighlightAllOccurencesOfStringForElement(document.body, keyword.toLowerCase());
}

// helper function, recursively(递归地) searches in elements and their child nodes
function MyApp_HighlightAllOccurencesOfStringForElement(element,keyword)
{
    if (element)
    {
        if (element.nodeType == 3)   // Text node
        {
            //循环的作用是找出一个element中所有的keyword而非仅第一个
            while (true)
            {
                var value = element.nodeValue;  // Search for keyword in text node
                
                //keyword第一次出现的位置（后面的element需继续搜索）
                var idx = value.toLowerCase().indexOf(keyword);
                
                if (idx < 0) break;             // not found, abort
                
                //begin----------若不高亮，则不需要-----------
                //高亮element
                var span = document.createElement("span");
                //把待高亮的文本插入span
                var text = document.createTextNode(value.substr(idx,keyword.length));
                span.appendChild(text);
                span.setAttribute("class","MyAppHighlight");
                span.style.backgroundColor="yellow";
                span.style.color="black";
                //end-----------若不高亮，则不需要------------

                //剩下未搜索的文本
                text = document.createTextNode(value.substr(idx+keyword.length));//substr(start,length)，start不可省略，若省略length，则从start一直到element的结尾
                
                //begin----------若不高亮，则不需要-----------
                //把剩下未搜索的文本（包括本次找到的keyword）都删掉。后面要重新插入
                element.deleteData(idx, value.length - idx);//deleteData(offset,count)从offset指定的位置开始删除count个字符
                
                //把高亮区及剩下未搜索的文本再依次插入到element的父节点中，已恢复原来的内容不变
                
                //next与element同级，相当于element所在文本段落的下一个段落
                var next = element.nextSibling;
                element.parentNode.insertBefore(span, next);//insertBefore(new,existing)
                element.parentNode.insertBefore(text, next);
                //end-----------若不高亮，则不需要------------
                
                //element更新为剩下未搜索的文本
                element = text;
                
                //找到的结果数+1
                MyApp_SearchResultCount++;	// update the counter
            }//while
        }else if (element.nodeType == 1)// Element node
        {
            if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select')
                for (var i=element.childNodes.length-1; i>=0; i--)
                    //递归调用
                    MyApp_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword);
        }
    }
}

// the main entry point to remove the highlights
function MyApp_RemoveAllHighlights() {
    MyApp_SearchResultCount = 0;
    MyApp_RemoveAllHighlightsForElement(document.body);
}

// helper function, recursively removes the highlights in elements and their childs
function MyApp_RemoveAllHighlightsForElement(element)
{
    if (element)
    {
        if (element.nodeType == 1)   //element node
        {
            if (element.getAttribute("class") == "MyAppHighlight")
            {
                var text = element.removeChild(element.firstChild);
                element.parentNode.insertBefore(text,element);
                element.parentNode.removeChild(element);
                return true;
            } else
            {
                var normalize = false;
                for (var i=element.childNodes.length-1; i>=0; i--)
                {
                    if (MyApp_RemoveAllHighlightsForElement(element.childNodes[i])) {
                        normalize = true;
                    }
                }
                if (normalize) {
                    element.normalize();//normalize() 方法移除空的文本节点，并连接相邻的文本节点
                }
            }
        }
    }
    return false;
}








