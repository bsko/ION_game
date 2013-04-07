package  
{
	import flash.display.Stage;
	import flash.media.SoundMixer;
	import LeaderBoardsPage.HighscoresControll;
	import structs.DifficultyLevel;
	import vk.APIConnection;
	/**
	 * ...
	 * @author iam
	 */
	public class App 
	{
		//playtomic information:
		public static const SWF_ID:int = 4521;
		public static const GUID:String = "19b9801d00ca41cd";
		public static const APIkey:String = "ab014fbcd2a34f7b9819d41ce14965";
		public static const TableName:String = "highscores";
		//-------
		
		public static const TEXTS_ARRAY:Array = ["Впервые  iPhone был анонсирован Стивом Джобсом на конференции  MacWorld Expo 9 января 2007 года. В продажу поступил 29 июня 2007 года и быстро завоевал существенную часть рынка смартфонов в США.",
												"7 июня 2010 года был представлен  iPhone 4 с обновленной операционной системой (iPhone OS в этот же день получила новое название — «Apple iOS»), имеющий ряд значительных преимуществ над предшественниками, включая более мощный центральный процессор  Apple A4, дисплей  Retina с разрешением 640 × 960 пикселей, 5 Мп камеру, а также камеру для видеосвязи (0,3 Мп).",
												"Android — операционная система для коммуникаторов, планшетных компьютеров, цифровых проигрывателей, цифровых фоторамок, наручных часов, нетбуков и смартбуков, основанная на ядре  Linux.",
												"Планшетный компьютер - (англ. Tablet computer или же электронный планшет) — собирательное понятие, включающее различные типы компьютеров (устройств) с сенсорным экраном. Планшетным компьютером можно управлять прикосновениями руки или стилуса. Клавиатура и мышь доступны не всегда.",
												"Ноутбук (англ. notebook — блокнот, блокнотный ПК) - портативный персональный компьютер, в корпусе которого объединены типичные компоненты ПК, включая дисплей, клавиатуру и устройство указания (обычно сенсорная панель, или тачпад), карманный компьютер, а также аккумуляторные батареи.",
												"Sony Ericsson активно сотрудничает с  Vodafone и производит множество телефонов для обычных  GSM и 3G. Исследовательские центры компании расположены в Швеции, Японии, Китае, США и Великобритании.",
												"На начало 2011 года  Sony Ericsson является 6-м производителем в мире по количеству проданных мобильных телефонов и смартфонов (после  Nokia, Samsung, LG Electronics, RIM и  Apple), доля компании на мировом рынке составляет 3,6 %.",
												"Во всех телефонах  Sony Ericsson есть система тестов, позволяющая узнать служебную информацию, параметры услуг, использовать служебные тесты и увидеть все слова в телефоне. Код ко входу: →,*,← ← *,← * (вводить в режиме ожидания, не обращая внимание на то, что происходит на экране)",
												"12 августа 2009 года  Nokia и  Microsoft заключили соглашение о партнерстве. В рамках соглашения разработчики  Nokia и  Microsoft приступают к созданию  Microsoft Office Mobile и корпоративных инструментов связи для смартфонов  Nokia, работающих под управлением операционной системы  Symbian."
												]
		public static const APPLICATION_URL:String = "http://vkontakte.ru/app2450748";
		public static const WINDOW_WIDTH:int = 800;
		public static const WINDOW_HEIGHT:int = 600;
		public static const DEG_TO_RAD:Number = Math.PI / 180;
		public static const RAD_TO_DEG:Number = 180 / Math.PI;
		public static const NORMAL_LEVEL:int = 201;
		public static const DINNER_LEVEL:int = 202;
		
		// экземпляры базовых классов
		public static var universe:Universe;
		public static var userInterface:Interface;
		public static var root:Main;
		public static var stage:Stage;
		public static var backgroundMenu:BackgroundMenu;
		public static var HighscoresController:HighscoresControll;
		public static var SoundMngr:SoundsManager = new SoundsManager();
		public static var apiConnection:APIConnection;
		
		public static var UserName:String;
		public static var UserLastName:String;
		public static var Total_SCORE:int;
		public static var levelsArray:Array = [];
		public static var isOnPause:Boolean = false;
		public static var LastSavedScore:int = -1;
		public static var DELIMITER:String = "^^^^";
		
		public static var sound:Boolean = true;
		
		public static function InitDifficultyLevels():void 
		{
			levelsArray.length = 0;
			var level:DifficultyLevel = new DifficultyLevel(50, 30, 1, "Первый уровень, утро, 9:00");
			levelsArray.push(level);
			level = new DifficultyLevel(45, 10, 1.2, "Второй уровень, 10:00");// , true, 1);
			levelsArray.push(level);
			level = new DifficultyLevel(40, 10, 1.5, "Третий уровень, 11:00", true, 0);
			levelsArray.push(level);
			level = new DifficultyLevel(37, 10, 1, "Четвертый уровень: \"ОБЕД!\", ешь сколько сможеш!", true, 1, DINNER_LEVEL);
			levelsArray.push(level);
			level = new DifficultyLevel(32, 10, 1.5, "Пятый уровень, вторая половина дня, 13:00", true, 0.1);
			levelsArray.push(level);
			level = new DifficultyLevel(28, 15, 2, "Шестой уровень, 14:00", true, 0.1);
			levelsArray.push(level);
			level = new DifficultyLevel(23, 10, 2.5, "Седьмой уровень, 15:00", true, 0.1);
			levelsArray.push(level);
			level = new DifficultyLevel(20, 5, 3, "Восьмой уровень, 16:00", true, 0.1);
			levelsArray.push(level);
		}
	}

}