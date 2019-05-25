package com.sun3d.why.util;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

/**
 * @author zhangshun
 *
 */
public class NsExcelReadXUtils {

	private XSSFWorkbook workbook;
	private XSSFSheet sheet;
	private int rowNumber;

	/**
	 *
	 * 通过文件绝对路径读取07版本以上excel的构造函数
	 *
	 * @author huangmin
	 * @param filePath
	 * @param sheetIndex
	 * @throws FileNotFoundException
	 */
	public NsExcelReadXUtils(final String filePath, final int sheetIndex) throws FileNotFoundException {
		this(new FileInputStream(filePath), sheetIndex);
	}

	/**
	 * 通过文件输入流读取07版本以上excel的构造函数
	 *
	 * @author huangmin
	 * @param is
	 *            文件输入流
	 * @param sheetIndex
	 *            工作簿的索引
	 */
	public NsExcelReadXUtils(InputStream is, final int sheetIndex) {
		// 获取wb
		try {
			if (is == null) {
				System.out.println("-a");
				this.setWorkbook(null);
				this.setSheet(null);
				this.setRowNumber(0);
				throw new RuntimeException("EXCEL文件出错，请检查！");
			}
			else {

				// 获取一个工作簿
				this.setWorkbook(new XSSFWorkbook(is));
				// 获取一个工作表
				this.setSheet(this.workbook.getSheetAt(sheetIndex));
				// 总行数
				this.setRowNumber(this.sheet.getLastRowNum() + 1);
			}
		}
		catch (final IOException e) {
			final String errorMessage = "读取文件失败";
			throw new RuntimeException(errorMessage, e);
		}
		finally {
			if (is != null) {
				try {
					is.close();
				}
				catch (final IOException e) {
					final String errorMessage = "关闭失败";
					throw new RuntimeException(errorMessage, e);
				}
				is = null;
			}
		}
	}

	/**
	 *
	 * 获取从起始行到EXCEL文件结束行的所有单元格数据集 (2015-6-23)
	 *
	 * @author huangmin
	 * @param startIndex
	 *            起始行索引，从0开始
	 * @param cellNum
	 *            excel模板的最大列数
	 * @return
	 */
	public List<List<String>> getLists(final int startIndex, final int cellNum) {
		return this.getLists(startIndex, this.getRowNumber() - 1, cellNum);
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
	public List<List<String>> getLists(int startIndex, int endIndex, final int cellNum) {
		final List<List<String>> rowList = new ArrayList<List<String>>();
		if (startIndex < 0) {
			startIndex = 0;
		}
		if (endIndex >= this.getRowNumber()) {
			endIndex = this.getRowNumber() - 1;
		}
		for (int i = startIndex; i <= endIndex; i++) {
			final List<String> cellList = this.getRowValue(i, cellNum);// new ArrayList<String>();
			if (cellList != null) {
				rowList.add(cellList);
			}
		}
		return rowList;
	}

	/**
	 * 获取EXCEL文件某一行的最大列数
	 *
	 * @param rowIndex
	 * @return
	 */
	public int getCellNum(final int rowIndex) {
		int cellNum = 0;
		if (this.getRowNumber() == 0) {
			return cellNum;
		}
		final XSSFRow row = this.getSheet().getRow(rowIndex);
		for (final Iterator<Cell> it = row.cellIterator(); it.hasNext();) {
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
	public List<String> getRowValue(final int rowIndex, final int cellNum) {
		final List<String> list = new ArrayList<String>();
		final XSSFRow row = this.getSheet().getRow(rowIndex);
		// 判断此行是否有数据
		// 判断此行所有单元格里数据是否全部为空
		boolean isRowBlank = true;
		if (row != null) {
			for (int j = 0; j < cellNum; j++) {
				final XSSFCell aCell = row.getCell(j);
				String s = "";
				if (aCell != null) {
					try {
						s = this.getCell(aCell);
					}
					catch (final Exception e) {
						final String msg = "第" + (rowIndex + 1) + "行，第" + j + "列，数据异常";
						//throw new NormStarRuntimeException(msg, e);
						throw new RuntimeException(msg);
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

	private String getCell(final XSSFCell aCell) {
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

	public XSSFWorkbook getWorkbook() {
		return this.workbook;
	}

	public void setWorkbook(final XSSFWorkbook workbook) {
		this.workbook = workbook;
	}

	public XSSFSheet getSheet() {
		return this.sheet;
	}

	public void setSheet(final XSSFSheet sheet) {
		this.sheet = sheet;
	}

	/**
	 * 获取EXCEL文件的总行数 huangmin(2015-1-5)
	 *
	 * @return
	 */
	public int getRowNumber() {
		return this.rowNumber;
	}

	public void setRowNumber(final int rowNumber) {
		this.rowNumber = rowNumber;
	}

}
