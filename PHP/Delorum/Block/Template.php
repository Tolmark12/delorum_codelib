<?php
/**
 * Delorum Framework
 *
 * LICENSE
 *
 * This source file is subject to the new BSD license that is bundled
 * with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://framework.delorum.com/license/new-bsd
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@delorum.com so we can send you a copy immediately.
 *
 * @category   Delorum
 * @package    Delorum_Block
 * @copyright  Copyright (c) 2009 Delorum Inc. (http://www.delorum.com)
 * @license    http://framework.delorum.com/license/new-bsd     New BSD License
 * @version    1.0
 */

/**
 * Block Template
 * 
 * This type of block is designed for working with template
 * files. All instances of this class must be accompanied
 * with a .phtml template. Template files can call instance
 * methods and also have access to instance variables.
 * 
 * This type of block is equiped with caching functionality
 * and will work by simply declaring useCache(true); More caching
 * options are available.
 * 
 * @category	Delorum
 * @package		Delorum_Block
 * @author		Tyler Flint <tflint@delorum.com>
 */
class Delorum_Block_Template extends Delorum_Block_Abstract
{
	/**
	 * .phtml template
	 *
	 * @var string
	 */
	protected $_template;
	
	/* cache  options */
	
	/**
	 * Use cache switch
	 *
	 * @var boolean
	 */
	protected $_useCache			= false;
	/**
	 * Unique cache id
	 *
	 * @var string
	 */
	protected $_cacheId;
	/**
	 * Frontend Cache type
	 *
	 * @var string
	 */
	protected $_frontendCache		= 'Core';
	/**
	 * Backend cache type
	 *
	 * @var string
	 */
	protected $_backendCache		= 'File';
	/**
	 * Cache lifetime
	 *
	 * @var int
	 */
	protected $_cacheLifetime		=  3600;
	/**
	 * Directory to store cache files
	 *
	 * @var string
	 */
	protected static $_cacheDir		= '/tmp/';
	
	/**
	 * Return the output of parsed template
	 *
	 * @return string output
	 */
	protected function _toHtml()
	{
		ob_start();
		include Delorum_Layout::getViewsDirectory() . "templates/" . $this->_template;
		$html = ob_get_clean();
		return $html;
	}
	
	/**
	 * Set cache directory
	 *
	 * @param string $dir
	 */
	public static function setCacheDir($dir)
	{
		self::$_cacheDir = $dir;
	}
	
	/**
	 * Set template
	 *
	 * @param string $template
	 */
	public function setTemplate($template)
	{
		$this->_template = $template;
	}
	
	/**
	 * Set cache switch state
	 *
	 * @param boolean $state
	 */
	public function useCache($state)
	{
		$this->_useCache = (bool) $state;
	}
	
	/**
	 * Set unique cache id
	 *
	 * @param string $id
	 */
	public function setCacheId($id)
	{
		$this->_cacheId = (string) $id;	
	}
	
	/**
	 * Set cache lifetime
	 *
	 * @param int $time
	 */
	public function setCacheLifetime($time)
	{
		$this->_cacheLifetime = $time;	
	}
	
	/**
	 * Set backend cache type
	 *
	 * @param string $type
	 */
	public function setBackendCacheType($type)
	{
		$this->_backendCache = $type;
	}
	
	/**
	 * Set frontend cache type
	 *
	 * @param string $type
	 */
	public function setFrontendCacheType($type)
	{
		$this->_frontendCache = $type;
	}
	
	/**
	 * Determines whether to parse template, or simply return cache value
	 *
	 * @return string html
	 */
	public function toHtml()
	{
		if(!$this->_template)
			return;
			
		if($this->_useCache){
			$cache = Zend_Cache::factory($this->_frontendCache, $this->_backendCache , array('lifetime'=>$this->_cacheLifetime), array('cache_dir'=>self::$_cacheDir));
			if(!$data = $cache->load($this->_cacheId)){
				$data = $this->_toHtml();
				$cache->save($data, $this->_cacheId);
				return $data;
			}else{
				return $data;
				
			}
		}else{
			return $this->_toHtml();
		}
		
	}
	
}