   M S B A M L   `   `   `  ����� 5   	   \  XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation     R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml      5   	     � Title$  Posh ConfigMgr Console��5   	   $	��350��6(   $	��525��65    � WindowStartupLocation$ CenterScreen=�6A   .��5      �  � ColumnDefinitions 5   
   �� 5      $��1* �6   �� 5      $��4 �6   �� 5	      $��3* �6    � RowDefinitions 5   
   �� 5      $��23 �6   �� 5      $��* �6   .+�5   
   o� $��4��6   .@�5      m� $
��File��6   $��Center=�6%   .@�5      m� -   5        $��
MI_Connect��5      $��Connect to Server��6-   m� 5      -   5        $��MI_Exit��5      $
��Exit��6*   5      5      R� 5   
   -   5        $��Tree_MainMenu��5      $��1��6(   $��0��65   .@�5      Q� $��Administration��6   .@�5      Q� $��
Boundaries��6   
 � Tag$ 0��63   5      5      �� 5   
   $��1��6   $��1��6$    �� ResizeDirection$ Columns=�64   $��Stretch=�6N   $��Stretch=�6l   �� 5   
   -   5        $��MainTabControl��5      $��1��6+   $��2��68    �� SelectedIndex 6H   ��  �� Path$ TabControlSelectedIndex�.@�5      �� $y�	Collapsed=�6   .��5      �  5      �� 5      $��25 �6(   �� 5       $��2* �6(   �� 5!      $��4 �6(   �� 5"      $��* �6(    5$      �� 5%      $��* �6+   �� 5&      $��* �6+   .+�5(      �� $��2��6#   $��0��60   $
 Rows=�6@   $��Stretch=�6W   $��Stretch=�6u   $��3��6�   �� 5)      $��Filter:��6   $��Right=�6.   �� 5*      -   5        $��Txt_BoundaryFilter��5*      $��0��68   $��2��6E   $��Center=�6U   ��6w   �� *BoundaryFilterText+&     System.Windows.Controls.DataGrid   5+      $��1��6   $��3��6,   $��5,5,5,5q�6e   ��6@   �� *BoundaryGrid+ � ContextMenu 5,      �� 5-      .@�5.   "   m� -   5        $��BoundaryProperties��5.   +   $��
Properties��6E   m� 5/   "   -   5        $��BoundaryDelete��5/   +   $��Delete��6A   50      52      53      54      55      56      57      