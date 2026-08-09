$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$s = 300
$bmp = New-Object System.Drawing.Bitmap($s,$s,[System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.Clear([System.Drawing.Color]::Transparent)

# 背景:圆角矩形 橙色渐变
$bgRect = New-Object System.Drawing.RectangleF([single]0,[single]0,[single]$s,[single]$s)
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$r = 40
$d = $r*2
$path.AddArc(0,0,$d,$d,180,90)
$path.AddArc($s-$d,0,$d,$d,270,90)
$path.AddArc($s-$d,$s-$d,$d,$d,0,90)
$path.AddArc(0,$s-$d,$d,$d,90,90)
$path.CloseFigure()
$c1 = [System.Drawing.Color]::FromArgb(255,255,126,79)
$c2 = [System.Drawing.Color]::FromArgb(255,255,154,107)
$brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($bgRect,$c1,$c2,30)
$g.FillPath($brush,$path)

# 白色碗(居中偏上)
$scale = $s/256.0
$g.FillEllipse((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)),[single](38*$scale),[single](30*$scale),[single](180*$scale),[single](180*$scale))

# 碗内橙点
$dots = @(@(96,120,13),@(128,130,12),@(156,120,13))
foreach($pt in $dots){
  $cx=$pt[0]*$scale;$cy=$pt[1]*$scale;$cr=$pt[2]*$scale
  $g.FillEllipse((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255,255,126,79))),$cx-$cr,$cy-$cr,$cr*2,$cr*2)
}
# 蒸汽
$g.FillEllipse((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255,255,201,163))),[single](184*$scale)-[single](13*$scale),[single](30*$scale)-[single](13*$scale),[single](26*$scale),[single](26*$scale))

# 底部标题文字
$font = New-Object System.Drawing.Font("Microsoft YaHei UI",[single]26,[System.Drawing.FontStyle]::Bold)
$textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$fmt = New-Object System.Drawing.StringFormat
$fmt.Alignment = [System.Drawing.StringAlignment]::Center
$txtRect = New-Object System.Drawing.RectangleF([single]0,[single]232,[single]300,[single]48)
$g.DrawString("吃喝大事 · 点餐神器",$font,$textBrush,$txtRect,$fmt)

$out = 'C:\Users\Administrator\Desktop\吃喝大事\share.jpg'
$bmp.Save($out,[System.Drawing.Imaging.ImageFormat]::Jpeg)
$g.Dispose();$bmp.Dispose()
"分享图已生成: $out  ($((Get-Item $out).Length) 字节)"