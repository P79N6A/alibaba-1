package com.sun3d.why.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.DVConstraint;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataValidation;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellRangeAddressList;
import org.apache.poi.ss.util.RegionUtil;

/**
 * 导出为Excel
 * 
 * @author huangmin
 * 
 */
public class NsExcelWriteUtils {

	private HSSFWorkbook workBook;
	private String filePath;
	private HSSFSheet sheet;
	private HSSFRow row;
	private HSSFCell cell;

	public HSSFWorkbook getWorkBook() {
		return this.workBook;
	}

	public void setWorkBook(final HSSFWorkbook workBook) {
		this.workBook = workBook;
	}

	public String getFilePath() {
		return this.filePath;
	}

	public void setFilePath(final String filePath) {
		this.filePath = filePath;
	}

	public HSSFSheet getSheet() {
		return this.sheet;
	}

	public void setSheet(final HSSFSheet sheet) {
		this.sheet = sheet;
	}

	public HSSFRow getRow() {
		return this.row;
	}

	public void setRow(final HSSFRow row) {
		this.row = row;
	}

	public HSSFCell getCell() {
		return this.cell;
	}

	public void setCell(final HSSFCell cell) {
		this.cell = cell;
	}

	/**
	 * 构造函数，创建一个EXCEL文件的工作簿 workbook，
	 * 
	 * @param filePath
	 *            文件路径名称
	 */
	public NsExcelWriteUtils(final String filePath) {
		this.filePath = filePath;
		this.workBook = new HSSFWorkbook();
	}

	/**
	 * 创建工作表
	 * 
	 * @param sheetName
	 *            工作表名称
	 */
	public void createSheet(final String sheetName) {
		this.sheet = this.workBook.createSheet(sheetName);
	}

	/**
	 * 创建一行
	 * 
	 * @param rowIndex
	 *            行索引,从0开始
	 */
	public void createRow(final int rowIndex) {
		this.row = this.sheet.createRow(rowIndex);
	}

	/**
	 * 创建一个单元格，并写入值
	 * 
	 * @param cellIndex
	 *            单元格索引
	 * @param value
	 *            内容
	 */
	public void createCell(final int cellIndex, final String value) {
		this.cell = this.row.createCell(cellIndex);
		this.cell.setCellValue(value);
	}

	/**
	 * 合并单元格
	 * 
	 * @param startRowIndex
	 *            起始的单元格行索引
	 * @param startCellIndex
	 *            起始的单元格列索引
	 * @param hLength
	 *            横向合并几列 正数表示向右合并，负数表示向左合并
	 * @param vLength
	 *            纵向合并几行 正数表示向下合并，负数表示向上合并
	 * @param style
	 *            单元格样式
	 */
	public void setMergedCell(
			final int startRowIndex,
			final int startCellIndex,
			final int hLength,
			final int vLength,
			final HSSFCellStyle style) {

		int firstRow = startRowIndex;
		int lastRow = (startRowIndex + vLength) - 1;
		int firstCol = startCellIndex;
		int lastCol = (startCellIndex + hLength) - 1;
		if (vLength < 0) {
			lastRow = firstRow;
			firstRow = startRowIndex + vLength + 1;
		}
		if (hLength < 0) {
			lastCol = firstCol;
			firstCol = startCellIndex + hLength + 1;
		}

		// System.out.print(firstRow+",");
		// System.out.print(lastRow);
		// System.out.print(","+firstCol+",");
		// System.out.println(lastCol);
		final CellRangeAddress region = new CellRangeAddress(firstRow, lastRow, firstCol, lastCol);
		this.sheet.addMergedRegion(region);

		if (style != null) {
			RegionUtil.setBorderBottom(style.getBorderBottom(), region, this.sheet, this.workBook);

			RegionUtil.setBorderTop(style.getBorderTop(), region, this.sheet, this.workBook);

			RegionUtil.setBorderLeft(style.getBorderLeft(), region, this.sheet, this.workBook);

			RegionUtil.setBorderRight(style.getBorderRight(), region, this.sheet, this.workBook);
		}

	}

	/**
	 * 合并单元格
	 * 
	 * @param startRowIndex
	 *            起始的单元格行索引
	 * @param startCellIndex
	 *            起始的单元格列索引
	 * @param hLength
	 *            横向合并几列 正数表示向右合并，负数表示向左合并
	 * @param vLength
	 *            纵向合并几行 正数表示向下合并，负数表示向上合并
	 */
	public void setMergedCell(final int startRowIndex, final int startCellIndex, final int hLength, final int vLength) {
		this.setMergedCell(startRowIndex, startCellIndex, hLength, vLength, null);
	}

	/**
	 * 
	 * 设置某些列的值只能输入预制的数据,显示下拉框.
	 * 
	 * @param sheet
	 *            要设置的sheet.
	 * @param textList
	 *            下拉框显示的内容
	 * @param firstRow
	 *            开始行
	 * @param endRow
	 *            结束行
	 * @param col
	 *            列
	 * @return 设置好的sheet.
	 */
	public HSSFSheet setHSSFValidation(final String[] textList, final int firstRow, final int endRow, final int col) {
		return this.setHSSFValidation(textList, firstRow, endRow, col, col);
	}

	/**
	 * 设置某些列的值只能输入预制的数据,显示下拉框.
	 * 
	 * @param sheet
	 *            要设置的sheet.
	 * @param textList
	 *            下拉框显示的内容
	 * @param firstRow
	 *            开始行
	 * @param endRow
	 *            结束行
	 * @param firstCol
	 *            开始列
	 * @param endCol
	 *            结束列
	 * @return 设置好的sheet.
	 */
	public HSSFSheet setHSSFValidation(
			final String[] textList,
			final int firstRow,
			final int endRow,
			final int firstCol,
			final int endCol) {
		// 加载下拉列表内容
		final DVConstraint constraint = DVConstraint.createExplicitListConstraint(textList);
		// 设置数据有效性加载在哪个单元格上,四个参数分别是：起始行、终止行、起始列、终止列
		final CellRangeAddressList regions = new CellRangeAddressList(firstRow, endRow, firstCol, endCol);
		// 数据有效性对象
		final HSSFDataValidation data_validation_list = new HSSFDataValidation(regions, constraint);
		this.sheet.addValidationData(data_validation_list);
		return this.sheet;
	}

	/**
	 * 最后创建Excel文件
	 * 
	 * @throws Exception
	 */
	public void createExcel() throws Exception {
		FileOutputStream fileOut = null;
		try {
			fileOut = new FileOutputStream(this.filePath);
			this.workBook.write(fileOut);
		}
		catch (final Exception e) {
			e.printStackTrace();
		}
		finally {
			if (fileOut != null) {
				fileOut.close();
			}
			fileOut = null;
		}
	}
	
	/**
	 * 
	 * 通过文件流下载文件 huangmin(2013-8-9).
	 * 
	 * @param fis
	 *            文件流
	 * @param fileName
	 *            要保存的文件名称
	 * @param response
	 */
	public static void downLoadFileByInputStream(
			final File file,
			final String fileName,
			final HttpServletResponse response) {
		BufferedInputStream bis = null;
		BufferedOutputStream bos = null;
		OutputStream fos = null;
		try {
			response.reset();
			response.setContentType("application/octet-stream");

			response.addHeader("Content-Disposition",
					"attachment;filename=" + java.net.URLEncoder.encode(fileName.toString(), "utf-8"));
			// response.addHeader("Content-Disposition", "attachment;filename="
			// + new String(fileName.getBytes(), "ISO8859-1"));

			bis = new BufferedInputStream(new FileInputStream(file));
			fos = response.getOutputStream();
			bos = new BufferedOutputStream(fos);
			int bytesRead = 0;
			final byte[] buffer = new byte[5 * 1024];
			while ((bytesRead = bis.read(buffer)) != -1) {
				bos.write(buffer, 0, bytesRead);// 将文件发送到客户端
			}
		}
		catch (final Exception e) {
			// 下载文件异常~
			final String errorMessage = "下载文件异常";
		}
		finally {
			if (bos != null) {
				try {
					bos.close();
				}
				catch (final IOException e) {
					final String errorMessage = "下载文件关闭流异常";
				}
			}
			if (fos != null) {
				try {
					fos.close();
				}
				catch (final IOException e) {
					final String errorMessage = "下载文件关闭流异常";
				}
			}
			if (bis != null) {
				try {
					bis.close();
				}
				catch (final IOException e) {
					final String errorMessage = "下载文件关闭流异常";
				}
			}
			
		}
	}

	
}
