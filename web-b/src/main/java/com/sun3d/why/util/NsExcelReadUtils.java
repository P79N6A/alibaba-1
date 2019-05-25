package com.sun3d.why.util;

import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;


/**
 * @author zhangshun
 *
 */
public class NsExcelReadUtils {

	private HSSFWorkbook workbook;
	private HSSFSheet sheet;
	private int rowNumber;

	public HSSFWorkbook getWorkbook() {
		return this.workbook;
	}

	public void setWorkbook(final HSSFWorkbook workbook) {
		this.workbook = workbook;
	}

	public HSSFSheet getSheet() {
		return this.sheet;
	}

	public void setSheet(final HSSFSheet sheet) {
		this.sheet = sheet;
	}

	/**
	 * 总数据集，总行数
	 * 
	 * @return
	 */
	public int getRowNumber() {
		return this.rowNumber;
	}

	public void setRowNumber(final int rowNumber) {
		this.rowNumber = rowNumber;
	}

	/**
	 * 读取EXCEL构造函数
	 * 
	 * @param is
	 *            文件的流
	 * @param sheetIndex
	 *            工作表索引 -从0开始
	 */
	public NsExcelReadUtils(InputStream is, final int sheetIndex) {
		POIFSFileSystem poifs = null;
		// FileInputStream is = null;
		try {
			// final File file = new File(xlsFile);
			if (is == null) {
				poifs = null;
				this.setWorkbook(null);
				this.setSheet(null);
				this.setRowNumber(0);
			}
			else {
				// is = new FileInputStream(xlsFile);
				poifs = new POIFSFileSystem(is);
				// 声明一个工作簿
				this.setWorkbook(new HSSFWorkbook(poifs));
				// 声明一个工作表
				this.setSheet(this.workbook.getSheetAt(sheetIndex));
				// 总行数
				this.setRowNumber(this.sheet.getLastRowNum() + 1);
			}
		}
		catch (final Exception e) {
			final String errorMessage = "读取文件失败";
			throw new RuntimeException(errorMessage, e);
		}
		finally {
			try {
				if (is != null) {
					is.close();
					is = null;
				}
			}
			catch (final IOException e) {
				final String errorMessage = "关闭失败";
				throw new RuntimeException(errorMessage, e);
			}
		}
	}

	/**
	 * 获取EXCEL文件的最大列数
	 * 
	 * @param rowIndex
	 * @return
	 */
	public int getCellNum(final int rowIndex) {
		int cellNum = 0;
		if (this.getRowNumber() == 0) {
			return cellNum;
		}
		final HSSFRow row = this.getSheet().getRow(rowIndex);
		for (final Iterator it = row.cellIterator(); it.hasNext();) {
			it.next();
			cellNum++;
		}
		return cellNum;
	}

	/**
	 * 获取某行的数据,此行所有单元格的内容
	 * 
	 * @param rowIndex
	 *            行索引，从0开始
	 * @param cellNum
	 *            列数
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<String> getRowValue(final int rowIndex, final int cellNum) {
		final List<String> list = new ArrayList<String>();
		final HSSFRow row = this.getSheet().getRow(rowIndex);
		// 判断此行是否有数据
		// 判断此行所有单元格里数据是否全部为空
		boolean isRowBlank = true;
		if (row != null) {
			for (int j = 0; j < cellNum; j++) {
				final HSSFCell aCell = row.getCell(j);
				String s = "";
				if (aCell != null) {
					try {
						s = this.getCell(aCell);
					}
					catch (final Exception e) {
						final String msg = "第" + (rowIndex + 1) + "行，第" + j + "列，数据异常";
						throw new RuntimeException(msg, e);
					}
				}
				// 如果单元格里数据有效,则此行有数据
				if (s!=null&&s.length()>0) {
					isRowBlank = false;
				}
				list.add(s);
			}
		}
		if (!isRowBlank) {
			list.add(String.valueOf(rowIndex + 1));
			return list;
		}
		return null;
	}

	/**
	 * 获取从起始行到结束行的所有单元格数据集
	 * 
	 * @param startIndex
	 *            起始行索引，从0开始
	 * @param endIndex
	 *            结束行索引，小于总行数-1
	 * @param cellNum
	 *            excel模板的最大列数
	 * @return List<List<String>> 返回的数据中List[String]里最后一个元素是此条数据在excel文件里的所在行序号
	 */
	@SuppressWarnings("unchecked")
	public List<List<String>> getLists(int startIndex, int endIndex, final int cellNum) {
		final List<List<String>> rowList = new ArrayList<List<String>>();
		if (startIndex < 0) {
			startIndex = 0;
		}
		if (endIndex >= this.getRowNumber()) {
			endIndex = this.getRowNumber() - 1;
		}
		for (int i = startIndex; i <= endIndex; i++) {
			final List<String> cellList = this.getRowValue(i, cellNum);
			if (cellList != null) {
				rowList.add(cellList);
			}
		}
		return rowList;
	}

	private String getCell(final HSSFCell aCell) {
		String s = "";
		final int cellType = aCell.getCellType();
		switch (cellType) {
			case Cell.CELL_TYPE_NUMERIC: // 整形,日期
				if (DateUtil.isCellDateFormatted(aCell)) {
					// 如果是date类型则 ，获取该cell的date值
					final Date date = DateUtil.getJavaDate(aCell.getNumericCellValue());
					// s = UtilsTime.getDateYMD(date);
					s = DateUtils.formatDate(date);
				}
				else {
					s = new DecimalFormat("#.##").format(aCell.getNumericCellValue());
				}
				break;
			case Cell.CELL_TYPE_STRING: // 字符串型
				s = aCell.getStringCellValue().trim();
				break;
			case Cell.CELL_TYPE_FORMULA: // double 型
				s = String.valueOf(aCell.getNumericCellValue());
				break;
			case Cell.CELL_TYPE_BLANK: // 空字符
				break;
			case Cell.CELL_TYPE_BOOLEAN: // 布尔型
				s = String.valueOf(aCell.getBooleanCellValue());
				break;
			default:
				break;
		}

		return s;
	}
}
