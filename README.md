# iOS_Exam_Test
For iOS Exam


### 整體架構說明：

使用 MVVM 架構

1. ViewModel 控制網路提取 Service，UserDefault 存儲，刷新回調
2. Controller 控制 View 生命週期
3. View 僅有 Cell ，其餘寫進 Storyboard


### 未寫部分

1. 網路狀態切換
2. 無網狀態警示
3. Cache 持有時間（目前使用默認，一週時間過後無法再無網狀態使用我的最愛功能）
4. ViewModel 單例持有（Tab 同時存在，可使用單例優化）
5. 註釋不足