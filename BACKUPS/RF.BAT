del \SimaClip.v52\SimaCart\f\objs\Carte151.obj
del \SimaClip.v52\SimaCart\f\objs\Carte152.obj
del \SimaClip.v52\SimaCart\f\objs\Carte108.obj
del \SimaClip.v52\SimaCart\f\objs\Carte205.obj
del \SimaClip.v52\SimaCart\f\objs\Carte254.obj
del \SimaClip.v52\SimaCart\f\objs\Carte255.obj
del \SimaClip.v52\SimaCart\f\objs\Carte256.obj
del \SimaClip.v52\SimaCart\f\objs\Carte206.obj
del \SimaClip.v52\SimaCart\f\objs\Carte208.obj
del \SimaClip.v52\SimaCart\f\objs\Carte415.obj
del \SimaClip.v52\SimaCart\f\objs\Carte403.obj

del \SimaClip.v52\SimaCart\f\objs\FuncsFpg.obj
del \SimaClip.v52\SimaCart\f\objs\FuncsPuc.obj
del \SimaClip.v52\SimaCart\f\objs\OtExt211.obj
del \SimaClip.v52\SimaCart\f\objs\OtExt212.obj

del \SimaClip.v52\SimaCart\f\objs\FuncsMor.obj
del \SimaClip.v52\SimaCart\f\objs\OtrMor01.obj
del \SimaClip.v52\SimaCart\f\objs\OtrMor02.obj
del \SimaClip.v52\SimaCart\f\objs\OtrMor03.obj
del \SimaClip.v52\SimaCart\f\objs\OtrMor04.obj
del \SimaClip.v52\SimaCart\f\objs\OtrMor05.obj
del \SimaClip.v52\SimaCart\f\objs\OtrMor06.obj


clipper \SimaClip.v52\SimaCart\f\Carte151
clipper \SimaClip.v52\SimaCart\f\Carte152
clipper \SimaClip.v52\SimaCart\f\Carte108
clipper \SimaClip.v52\SimaCart\f\Carte205
clipper \SimaClip.v52\SimaCart\f\Carte254
clipper \SimaClip.v52\SimaCart\f\Carte255
clipper \SimaClip.v52\SimaCart\f\Carte256
clipper \SimaClip.v52\SimaCart\f\Carte206
clipper \SimaClip.v52\SimaCart\f\Carte208
clipper \SimaClip.v52\SimaCart\f\Carte415
clipper \SimaClip.v52\SimaCart\f\Carte403

clipper \SimaClip.v52\SimaCart\f\Funcions\FuncsFpg
clipper \SimaClip.v52\SimaCart\f\Funcions\FuncsPuc
clipper \SimaClip.v52\SimaCart\f\Funcions\OtExt211
clipper \SimaClip.v52\SimaCart\f\Funcions\OtExt212

clipper \SimaClip.v52\SimaCart\f\Funcions\FuncsMor
clipper \SimaClip.v52\SimaCart\f\Funcions\OtrMor01
clipper \SimaClip.v52\SimaCart\f\Funcions\OtrMor02
clipper \SimaClip.v52\SimaCart\f\Funcions\OtrMor03
clipper \SimaClip.v52\SimaCart\f\Funcions\OtrMor04
clipper \SimaClip.v52\SimaCart\f\Funcions\OtrMor05
clipper \SimaClip.v52\SimaCart\f\Funcions\OtrMor06

copy \SimaClip.v52\SimaCart\f\Carte151.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\Carte152.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\Carte108.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\Carte205.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\Carte254.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\Carte255.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\Carte256.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\Carte206.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\Carte208.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\Carte415.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\Carte403.obj \SimaClip.v52\SimaCart\f\objs

copy \SimaClip.v52\SimaCart\f\FuncsFpg.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\FuncsPuc.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\OtExt211.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\OtExt212.obj \SimaClip.v52\SimaCart\f\objs

copy \SimaClip.v52\SimaCart\f\FuncsMor.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\OtrMor01.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\OtrMor02.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\OtrMor03.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\OtrMor04.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\OtrMor05.obj \SimaClip.v52\SimaCart\f\objs
copy \SimaClip.v52\SimaCart\f\OtrMor06.obj \SimaClip.v52\SimaCart\f\objs

del *.obj
del ..\pluscart.*
call lnk\MakeCart %1
cd ..
pluscart
cd f