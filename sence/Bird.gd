extends RigidBody2D

#自调变量
@export var speed = 200
#待知变量
var screen_size
#节点变量
@onready var Animated = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#获取屏幕大小
	screen_size = get_viewport_rect().size
	#给个向右的线速度
	linear_velocity.x = speed
	#启用碰撞检测
	contact_monitor = true#没设置最大不知道会不会出错
	#var callable = Callable(self, "func_name")可以理解为用变量方式去使用函数(强大在于可随时更换函数)
	body_entered.connect(Callable(self, "on_body_enter_event"))#这是命令式绑定接受信号函数,与右侧标签页绑定不同,函数前没有绿箭头.而且这个函数接受就是callable


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#当向上时不能翻过头
	if rotation < deg_to_rad(-30):
		rotation = deg_to_rad(-30)
		angular_velocity = 0 
	#当向下时给它往下翻
	if linear_velocity.y > 0:
		angular_velocity = 2
		
	#当按下起飞键,给小鸟向上的速度, 和向上翻的角速度, 且暂时不受重力影响(效果更好), 播放动画和声音
	if Input.is_action_just_pressed("fly_buttom"):
		linear_velocity.y = -200
		angular_velocity = -2
		gravity_scale = 0
		Animated.play()
		$wing.play()
	#以播放动画结束作为还原状态标志
	if Animated.frame == 2:
		Animated.stop()
		Animated.frame = 0
		gravity_scale = 1
	
	
	position.y = clamp(position.y, 0, screen_size.y)

#碰撞到后发出声音
func on_body_enter_event():
	$hit.play()
	
