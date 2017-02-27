<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:html="http://www.w3.org/1999/xhtml"
	version="2.0">
	
	<xsl:param name="packages"/>
	
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="html:table">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		
			<xsl:for-each select="tokenize($packages, '\n\n+')">
				<xsl:element name="tr">
					<xsl:for-each select="tokenize(current(), '\n')">
						<xsl:choose>
							<xsl:when test="starts-with(current(), 'Package:')">
								<xsl:element name="td">
									<xsl:element name="a">
<!--										<xsl:attribute name="href" select="concat('binary/')"/>-->
										<xsl:value-of select="substring-after(current(), 'Package: ')"/>
									</xsl:element>
								</xsl:element>
							</xsl:when>
							<xsl:when test="starts-with(current(), 'MD5sum:')">
								<xsl:element name="td">
									<xsl:value-of select="substring-after(current(), 'MD5sum: ')"/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="starts-with(current(), 'Filename:')">
								<xsl:variable name="filename" select="substring-after(current(), 'Filename: ./')"/>
								<xsl:element name="td">
									<xsl:element name="a">
										<xsl:attribute name="href" select="concat('binary/', $filename)"/>
										<xsl:value-of select="$filename"/>
									</xsl:element>
								</xsl:element>
							</xsl:when>
							<!--<xsl:when test="starts-with(current(), 'Size:')">
								<xsl:element name="td">
									<xsl:value-of select="number(substring-after(current(), 'Size: ')) div 1000"/>
								</xsl:element>
							</xsl:when>-->
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>